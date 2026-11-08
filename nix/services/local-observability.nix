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
      otlp_http/luna:
        endpoint: http://luna.tailaf2ec2.ts.net:4318
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
          exporters: [otlp_http/luna]
        traces:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [otlp_http/luna]
        logs:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [otlp_http/luna]
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
              url = "http://luna.tailaf2ec2.ts.net:9090";
              isDefault = true;
            }
            {
              name = "Loki";
              type = "loki";
              uid = "loki";
              url = "http://luna.tailaf2ec2.ts.net:3100";
            }
            {
              name = "Tempo";
              type = "tempo";
              uid = "tempo";
              url = "http://luna.tailaf2ec2.ts.net:3200";
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
