{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.local-observability;

  otelConfig = pkgs.writeText "otel-collector-config.yaml" ''
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 127.0.0.1:4317
          http:
            endpoint: 0.0.0.0:4318

    processors:
      batch: {}
      memory_limiter:
        check_interval: 1s
        limit_percentage: 75
        spike_limit_percentage: 15

    exporters:
      prometheus:
        endpoint: 127.0.0.1:9464
      otlp/tempo:
        endpoint: 127.0.0.1:4327
        tls:
          insecure: true
      otlphttp/loki:
        endpoint: http://127.0.0.1:3100/otlp

    service:
      pipelines:
        metrics:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [prometheus]
        traces:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [otlp/tempo]
        logs:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [otlphttp/loki]
  '';
in
{
  options.services.local-observability = {
    enable = lib.mkEnableOption "personal local development observability stack";

    arabicaMetricsTarget = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1:9101";
      description = "Prometheus scrape target for Arabica's /metrics endpoint.";
    };

    grafanaDashboardsDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/grafana-dashboards";
      example = "/var/lib/grafana-dashboards";
      description = "Runtime path to a directory of Grafana dashboard JSON files.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.hasPrefix "/" cfg.grafanaDashboardsDir;
        message = "services.local-observability.grafanaDashboardsDir must be an absolute runtime path.";
      }
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.grafanaDashboardsDir} 0755 patrick grafana -"
    ];

    services.opentelemetry-collector = {
      enable = true;
      package = pkgs.opentelemetry-collector-contrib;
      configFile = otelConfig;
    };

    services.tempo = {
      enable = true;
      settings = {
        server.http_listen_port = 3200;
        distributor.receivers.otlp.protocols.grpc.endpoint = "127.0.0.1:4327";
        live_store = {
          shutdown_marker_dir = "/var/lib/tempo/live-store/shutdown-marker";
          wal.path = "/var/lib/tempo/live-store/traces";
        };
        backend_scheduler.local_work_path = "/var/lib/tempo/backend-scheduler";
        block_builder.wal.path = "/var/lib/tempo/block-builder/traces";
        storage.trace = {
          backend = "local";
          local.path = "/var/lib/tempo/traces";
          wal.path = "/var/lib/tempo/wal";
        };
      };
    };

    services.loki = {
      enable = true;
      configuration = {
        auth_enabled = false;
        server = {
          http_listen_port = 3100;
          grpc_listen_address = "127.0.0.1";
          grpc_listen_port = 9096;
        };
        common = {
          ring = {
            instance_addr = "127.0.0.1";
            kvstore.store = "inmemory";
          };
          replication_factor = 1;
          path_prefix = "/var/lib/loki";
        };
        schema_config.configs = [
          {
            from = "2020-10-24";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
        storage_config.filesystem.directory = "/var/lib/loki/chunks";
      };
    };

    services.prometheus = {
      enable = true;
      port = 9090;
      globalConfig.scrape_interval = "15s";
      scrapeConfigs = [
        {
          job_name = "otel-collector";
          static_configs = [ { targets = [ "127.0.0.1:9464" ]; } ];
        }
        {
          job_name = "arabica";
          static_configs = [ { targets = [ cfg.arabicaMetricsTarget ]; } ];
        }
      ];
    };

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_port = 3000;
          http_addr = "127.0.0.1";
        };
        "auth.anonymous" = {
          enabled = true;
          org_role = "Admin";
        };
        security.secret_key = "local-observability-insecure-secret-key";
      };
      provision = {
        enable = true;
        datasources.settings = {
          apiVersion = 1;
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              uid = "prometheus";
              url = "http://127.0.0.1:9090";
              isDefault = true;
            }
            {
              name = "Loki";
              type = "loki";
              uid = "loki";
              url = "http://127.0.0.1:3100";
            }
            {
              name = "Tempo";
              type = "tempo";
              uid = "tempo";
              url = "http://127.0.0.1:3200";
              jsonData = {
                tracesToLogsV2.datasourceUid = "loki";
                serviceMap.datasourceUid = "prometheus";
              };
            }
          ];
        };
        dashboards.settings = {
          apiVersion = 1;
          providers = [
            {
              name = "local";
              orgId = 1;
              folder = "";
              type = "file";
              disableDeletion = false;
              updateIntervalSeconds = 10;
              allowUiUpdates = true;
              options.path = cfg.grafanaDashboardsDir;
            }
          ];
        };
      };
    };
  };
}
