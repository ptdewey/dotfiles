{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.local-observability;

  isLocal = signal: cfg.routing.${signal} != "remote";
  isRemote = signal: cfg.routing.${signal} != "local";
  exportersFor =
    signal: localExporter:
    lib.optional (isLocal signal) localExporter ++ lib.optional (isRemote signal) "otlp_http/remote";
  datasourceHost = signal: if isLocal signal then "127.0.0.1" else cfg.remoteHost;

  otelConfig = pkgs.writeText "otel-collector-config.yaml" ''
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 127.0.0.1:4317
          http:
            endpoint: 0.0.0.0:4318
      prometheus:
        config:
          scrape_configs:
            - job_name: arabica
              scrape_interval: 15s
              static_configs:
                - targets: ["${cfg.arabicaMetricsTarget}"]

    processors:
      batch: {}
      memory_limiter:
        check_interval: 1s
        limit_percentage: 75
        spike_limit_percentage: 15
      attributes/host:
        actions:
          - key: host.name
            value: "${config.networking.hostName}"
            action: upsert

    exporters:
      prometheus:
        endpoint: 127.0.0.1:9464
      otlp/tempo:
        endpoint: 127.0.0.1:4327
        tls:
          insecure: true
      otlp_http/loki:
        endpoint: http://127.0.0.1:3100/otlp
      otlp_http/remote:
        endpoint: ${builtins.toJSON cfg.remoteCollectorEndpoint}
        timeout: 10s
        retry_on_failure:
          enabled: true
          initial_interval: 1s
          max_interval: 30s
          max_elapsed_time: 5m
        sending_queue:
          enabled: true
          num_consumers: 4
          queue_size: 1000

    service:
      pipelines:
        metrics:
          receivers: [otlp, prometheus]
          processors: [memory_limiter, attributes/host, batch]
          exporters: ${builtins.toJSON (exportersFor "metrics" "prometheus")}
        traces:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: ${builtins.toJSON (exportersFor "traces" "otlp/tempo")}
        logs:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: ${builtins.toJSON (exportersFor "logs" "otlp_http/loki")}
  '';
in
{
  options.services.local-observability = {
    enable = lib.mkEnableOption "personal local development observability stack";

    routing = lib.genAttrs [ "metrics" "traces" "logs" ] (
      signal:
      lib.mkOption {
        type = lib.types.enum [
          "local"
          "remote"
          "both"
        ];
        default = "local";
        description = "Where to store ${signal}. Both keeps the local backend and also forwards to the remote collector. Grafana queries local storage when both is selected.";
      }
    );

    remoteHost = lib.mkOption {
      type = lib.types.str;
      default = "luna.tailaf2ec2.ts.net";
      description = "Remote backend hostname used by Grafana and the default remote collector endpoint.";
    };

    remoteCollectorEndpoint = lib.mkOption {
      type = lib.types.str;
      default = "http://${cfg.remoteHost}:4318";
      description = "OTLP HTTP base URL for forwarding signals selected by routing.";
    };

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

    services.tempo = lib.mkIf (isLocal "traces") {
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

    services.loki = lib.mkIf (isLocal "logs") {
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

    services.prometheus = lib.mkIf (isLocal "metrics") {
      enable = true;
      port = 9090;
      globalConfig.scrape_interval = "15s";
      scrapeConfigs = [
        {
          job_name = "otel-collector";
          static_configs = [ { targets = [ "127.0.0.1:9464" ]; } ];
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
              url = "http://${datasourceHost "metrics"}:9090";
              isDefault = true;
            }
            {
              name = "Loki";
              type = "loki";
              uid = "loki";
              url = "http://${datasourceHost "logs"}:3100";
            }
            {
              name = "Tempo";
              type = "tempo";
              uid = "tempo";
              url = "http://${datasourceHost "traces"}:3200";
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
