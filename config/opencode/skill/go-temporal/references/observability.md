# Observability

## Table of Contents

- [Observability Strategy](#observability-strategy)
- [OpenTelemetry Integration](#opentelemetry-integration)
- [Tracing](#tracing)
- [Context Propagation](#context-propagation)
- [Baggage](#baggage)
- [Metrics](#metrics)
- [Logging](#logging)

---

## Observability Strategy

### Three Pillars for Temporal

| Pillar | Purpose | Temporal Specifics |
|--------|---------|-------------------|
| **Traces** | Request flow visualization | Spans for workflows, activities, child workflows |
| **Metrics** | Quantitative health monitoring | Temporal SDK metrics + custom business metrics |
| **Logs** | Detailed debugging | Correlated with trace IDs for searchability |

### Key Insight

Temporal workflows span long durations (minutes to months). Traditional request-scoped observability doesn't fit. Design for:
- **Long-lived traces**: Single trace may span days
- **Progress visibility**: Query workflow state, not just logs
- **Failure investigation**: Temporal history is primary debugging tool

---

## OpenTelemetry Integration

### Architecture

```
Workflow/Activity → OTel Interceptor → Tracer Provider → Exporter → Backend
                                    ↓
                              Propagator → Headers → Downstream Services
```

### Setup Components

1. **Tracer Provider**: Configures sampling, resource attributes, export destination
2. **Exporter**: Sends spans to backend (OTLP/gRPC, Jaeger, Zipkin)
3. **Propagator**: Injects/extracts trace context from carriers (headers)
4. **Tracing Interceptor**: Temporal-specific integration via `go.temporal.io/sdk/contrib/opentelemetry`

### Configuration Guidelines

- **Resource Attributes**: Set service name, version, environment for filtering
- **Sampling**: Use adaptive sampling in production; `AlwaysSample()` for development
- **Batch Export**: Use `WithBatcher()` for efficient export in production
- **Graceful Shutdown**: Always call `TracerProvider.Shutdown()` on exit

### Interceptor Registration

Register tracing interceptor with both client and worker:
- Client interceptor: Traces workflow starts, signals, queries
- Worker interceptor: Traces workflow and activity execution

---

## Tracing

### Automatic Spans

The OpenTelemetry interceptor creates spans for:
- Workflow start and execution
- Activity start and execution
- Child workflow start and execution
- Signals and queries (client-side)

### Span Hierarchy

```
StartWorkflow:OrderWorkflow
└── RunWorkflow:OrderWorkflow
    ├── StartActivity:ProcessPayment
    │   └── RunActivity:ProcessPayment
    │       └── (custom spans in activity)
    └── StartChildWorkflow:NotificationWorkflow
        └── RunWorkflow:NotificationWorkflow
```

### Automatic Attributes

| Attribute | Description |
|-----------|-------------|
| `temporalWorkflowID` | Workflow ID |
| `temporalRunID` | Workflow run ID |
| `temporalActivityID` | Activity ID (activity spans) |
| `temporalTaskQueue` | Task queue name |

### Custom Spans in Activities

Activities can create child spans using standard OpenTelemetry APIs:
- `tracer.Start(ctx, "span-name")` creates nested span
- Add attributes for relevant data (IDs, amounts, statuses)
- Add events for significant occurrences
- Record errors and set status codes

### Workflow Tracing Limitations

Workflows cannot use standard OpenTelemetry APIs (non-deterministic). Instead:
- Interceptor handles workflow spans automatically
- Use workflow logger for trace-correlated logs
- Create custom spans in activities, not workflows

---

## Context Propagation

### How It Works

Trace context automatically propagates across:
- Workflow → Activity
- Parent → Child workflow
- Activity → External service (with instrumented client)

The interceptor handles Temporal-internal propagation via workflow headers.

### Cross-Service Propagation

For external API calls from activities, propagate trace context:

**Instrumented HTTP Client**: Use `otelhttp.NewTransport()` for automatic injection.

**Manual Injection**: Call `otel.GetTextMapPropagator().Inject(ctx, carrier)` to add headers.

**Database Tracing**: Use instrumented drivers (e.g., `otelsql`) for automatic query spans.

### Propagator Types

| Propagator | Format | Use Case |
|------------|--------|----------|
| `TraceContext` | W3C standard | Modern systems, default choice |
| `Baggage` | W3C baggage | Key-value propagation |
| `B3` | Zipkin format | Legacy Zipkin systems |
| `Jaeger` | Jaeger format | Legacy Jaeger systems |

Use `CompositeTextMapPropagator` to support multiple formats.

---

## Baggage

### Purpose

Propagate key-value pairs across service boundaries without passing through function arguments. Use for:
- Tenant/customer ID
- Feature flags
- Request metadata
- Debug flags

### Setting Baggage

Create baggage members and attach to context before starting workflow or calling activity. Baggage propagates automatically through Temporal operations.

### Reading Baggage

Extract baggage from context in activities via `baggage.FromContext(ctx)`. Access members by key.

### Best Practices

| Do | Don't |
|----|-------|
| Keep values small (< 256 bytes) | Store large payloads |
| Use for cross-cutting concerns | Replace proper parameters |
| Document baggage contract | Include sensitive data |
| Use consistent naming | Overuse for app logic |

### Common Patterns

- `tenant.id`: Multi-tenancy routing
- `request.id`: Request correlation
- `feature.*`: Feature flag state
- `client.version`: Client version tracking
- `debug`: Enable verbose logging

---

## Metrics

### Temporal SDK Metrics

The SDK emits metrics for:
- Workflow/activity execution counts and latencies
- Task queue polling behavior
- Worker health and capacity
- Schedule-to-start latency (queue backlog indicator)

### OpenTelemetry Metrics Integration

Use `opentelemetry.NewMetricsHandler()` to export SDK metrics via OpenTelemetry:
- Pass meter from your meter provider
- Register handler in client options
- Export to Prometheus, OTLP, or other backends

### Custom Business Metrics

Create application-specific metrics in activities:
- **Counters**: Events, completions, failures
- **Histograms**: Durations, amounts, sizes
- **Attributes**: Tenant, status, type for cardinality

### Guidelines

- **Cardinality**: Limit attribute combinations to avoid metric explosion
- **Naming**: Use consistent prefix (e.g., `myapp_payments_total`)
- **Labels**: Include actionable dimensions (tenant, status, error_type)
- **Avoid**: Workflow IDs as labels (infinite cardinality)

---

## Logging

### Temporal Logger

Access via `workflow.GetLogger(ctx)` in workflows and `activity.GetLogger(ctx)` in activities:
- Automatically includes workflow/activity context
- Integrates with trace context when using interceptor
- Structured key-value format

### Trace Correlation

Include trace and span IDs in logs for correlation:
- Extract span context from Go context
- Add `trace_id` and `span_id` fields to log records
- Enables log → trace navigation in observability platforms

### Custom Logger Adapter

Adapt your preferred logger (slog, zap, zerolog) to Temporal's interface:
- Implement `log.Logger` interface (Debug, Info, Warn, Error methods)
- Pass adapter to `client.Options.Logger`
- Maintain consistent log format across application

### Logging Guidelines

| Do | Don't |
|----|-------|
| Log business events | Log every function entry/exit |
| Include correlation IDs | Log sensitive data |
| Use structured fields | Use string interpolation |
| Log errors with context | Swallow errors silently |

### Activity vs Workflow Logging

**Activities**: Use standard Go logging practices; context available normally.

**Workflows**: Use only `workflow.GetLogger()`; standard logging is non-deterministic.

### Log Levels

| Level | Use For |
|-------|---------|
| Debug | Detailed troubleshooting info |
| Info | Normal operations, business events |
| Warn | Recoverable issues, degraded operation |
| Error | Failures requiring attention |

Avoid excessive Debug logging in production; enable via configuration when needed.
