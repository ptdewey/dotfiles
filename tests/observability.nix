let
  flake = builtins.getFlake (toString ../.);
  lib = flake.inputs.nixpkgs.lib;
  evaluate =
    settings:
    (lib.nixosSystem {
      modules = [
        ../nix/services/local-observability.nix
        {
          nixpkgs.hostPlatform = "x86_64-linux";
          networking.hostName = "test";
          services.local-observability = {
            enable = true;
          }
          // settings;
        }
      ];
    }).config;
  check =
    routing:
    let
      config = evaluate { inherit routing; };
      destinations = {
        metrics = "local";
        traces = "local";
        logs = "local";
      }
      // routing;
      localSignal = signal: destinations.${signal} != "remote";
      collector = builtins.readFile config.services.opentelemetry-collector.configFile;
      expectedExporters =
        signal: exporter:
        builtins.toJSON (
          lib.optional (localSignal signal) exporter
          ++ lib.optional (destinations.${signal} != "local") "otlp_http/remote"
        );
      datasources = config.services.grafana.provision.datasources.settings.datasources;
    in
    assert config.services.prometheus.enable == localSignal "metrics";
    assert config.services.tempo.enable == localSignal "traces";
    assert config.services.loki.enable == localSignal "logs";
    assert config.services.opentelemetry-collector.enable;
    assert config.services.grafana.enable;
    assert lib.hasInfix ("exporters: " + expectedExporters "metrics" "prometheus") collector;
    assert lib.hasInfix ("exporters: " + expectedExporters "traces" "otlp/tempo") collector;
    assert lib.hasInfix ("exporters: " + expectedExporters "logs" "otlp_http/loki") collector;
    assert lib.all (
      entry:
      let
        signal =
          {
            prometheus = "metrics";
            tempo = "traces";
            loki = "logs";
          }
          .${entry.uid};
        host = if localSignal signal then "127.0.0.1" else "luna.tailaf2ec2.ts.net";
      in
      lib.hasPrefix ("http://" + host + ":") entry.url
    ) datasources;
    true;
  routes = [
    "local"
    "remote"
    "both"
  ];
  invalid = evaluate { routing.metrics = "invalid"; };
  disabled = evaluate { enable = false; };
  custom = evaluate {
    routing.metrics = "remote";
    remoteHost = "monitoring.example.test";
    remoteCollectorEndpoint = "https://collector.example.test";
  };
in
assert lib.all (
  metrics: lib.all (traces: lib.all (logs: check { inherit metrics traces logs; }) routes) routes
) routes;
assert !(builtins.tryEval invalid.services.local-observability.routing.metrics).success;
assert !disabled.services.opentelemetry-collector.enable;
assert !disabled.services.prometheus.enable;
assert !disabled.services.tempo.enable;
assert !disabled.services.loki.enable;
assert !disabled.services.grafana.enable;
assert lib.hasInfix "https://collector.example.test" (
  builtins.readFile custom.services.opentelemetry-collector.configFile
);
assert
  (builtins.head custom.services.grafana.provision.datasources.settings.datasources).url
  == "http://monitoring.example.test:9090";
"27 routing combinations, disabled stack, invalid route, and custom endpoints passed"
