# Observability routing

`services.local-observability` runs a local OpenTelemetry collector and Grafana.
Choose storage independently for each signal with `routing.metrics`,
`routing.traces`, and `routing.logs`:

| Value | Local backend | Forward to remote collector | Grafana queries |
| --- | --- | --- | --- |
| `local` (default) | Enabled | No | Local |
| `remote` | Disabled | Yes | Remote |
| `both` | Enabled | Yes | Local |

The local backends are Prometheus (metrics), Tempo (traces), and Loki (logs).
Europa uses the defaults. Callisto explicitly routes all three signals remotely.
The collector also scrapes `arabicaMetricsTarget` every 15 seconds; those metrics
follow the same metrics route as incoming OTLP metrics.

To keep everything on Europa and also send traces to Luna, add this to
`nix/hosts/nixos/europa/configuration.nix`:

```nix
services.local-observability = {
  enable = true;
  routing.traces = "both";
};
```

Use `"remote"` instead to stop running local Tempo and store traces only on Luna.
The same choices work independently for `routing.metrics` and `routing.logs`.
Routing applies to an entire signal, not individual applications.

`remoteHost` defaults to `luna.tailaf2ec2.ts.net`. Grafana uses ports 9090,
3100, and 3200 there for remote-only signals. `remoteCollectorEndpoint` defaults
to `http://${remoteHost}:4318` and can be overridden separately. The remote
collector and backends must already be configured and reachable; this module
does not deploy them or open firewall ports. Forwarding uses unencrypted HTTP,
so use a trusted network such as the existing tailnet or configure an HTTPS endpoint.

Run the routing regression checks from the repository root:

```sh
nix eval --impure --json --file tests/observability.nix
```

Changing routes does not delete existing backend data. Remote forwarding uses
a bounded in-memory retry queue, not durable storage; extended outages or a
collector restart can lose queued telemetry.
