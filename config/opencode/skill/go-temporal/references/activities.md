# Activity Patterns

## Table of Contents

- [Activity Configuration](#activity-configuration)
- [Heartbeating](#heartbeating)
- [Local Activities](#local-activities)
- [Async Completion](#async-completion)
- [Idempotency](#idempotency)
- [Error Handling](#error-handling)
- [Activity Organization](#activity-organization)

---

## Activity Configuration

### Timeout Types

| Timeout | Purpose | When to Set |
|---------|---------|-------------|
| `StartToCloseTimeout` | Max time for single attempt | Always (required) |
| `ScheduleToCloseTimeout` | Max time including all retries | When you have a hard deadline |
| `ScheduleToStartTimeout` | Max time waiting in queue | When queue backlog is a concern |
| `HeartbeatTimeout` | Max time between heartbeats | For long-running activities |

### Guidelines

- **Always set `StartToCloseTimeout`**: This is the fundamental activity timeout
- **Set `HeartbeatTimeout` to 1/3 of expected activity duration**: Gives reasonable detection time
- **Use `ScheduleToCloseTimeout` for business SLAs**: Bounds total retry time
- **Configure `ScheduleToStartTimeout` for worker pool issues**: Detects stuck queues

### Retry Policy Tuning

| Parameter | Purpose | Typical Values |
|-----------|---------|----------------|
| `InitialInterval` | First retry delay | 1s for transient, 10s+ for rate limits |
| `BackoffCoefficient` | Multiplier between retries | 2.0 (standard exponential) |
| `MaximumInterval` | Cap on retry delay | 1-5 minutes |
| `MaximumAttempts` | Total attempts (0=unlimited) | 5-10 for bounded, 0 for must-succeed |
| `NonRetryableErrorTypes` | Skip retry for these | Validation errors, not-found |

---

## Heartbeating

### When Required

- Activities running longer than 1 minute
- Batch processing with many items
- Network operations with unpredictable latency
- Any activity where progress matters for recovery

### Key Benefits

- **Failure Detection**: Worker crashes detected within heartbeat timeout
- **Progress Tracking**: Monitor activity progress from workflow/UI
- **Resumption**: Resume from last heartbeat on retry

### Design Guidelines

- **Heartbeat Frequency**: Every 10-30 seconds, or per significant progress unit
- **Heartbeat Content**: Store resumption state (index, cursor, checkpoint)
- **Granularity**: One heartbeat per logical progress unit (batch, record, page)

### Progress Recovery Pattern

On activity start:
1. Check `activity.HasHeartbeatDetails(ctx)`
2. If true, extract last progress via `activity.GetHeartbeatDetails(ctx, &progress)`
3. Resume from saved progress point
4. Continue heartbeating with updated progress

### Heartbeat Details Design

Keep heartbeat details:
- **Small**: Serialize efficiently; avoid large objects
- **Complete**: Enough to resume without external lookups
- **Idempotent**: Processing from checkpoint must be safe to repeat

---

## Local Activities

### When to Use

| Use Local Activities | Use Regular Activities |
|---------------------|----------------------|
| Validation logic | Network I/O |
| Data transformation | Database operations |
| Quick computations | External API calls |
| In-memory cache lookups | Long-running tasks |
| Decisions requiring workflow state | Operations needing heartbeats |

### Constraints

- Must complete within 10 seconds (configurable)
- No heartbeat support
- Retries don't persist across worker restarts
- Executes in same worker as workflow

### Guidelines

- **Timeout**: Set `StartToCloseTimeout` shorter than 10 seconds
- **Retry**: Use minimal retry policy; failures escalate to workflow quickly
- **Idempotency**: Still required; local activities retry within worker
- **State Access**: Can receive workflow state directly without serialization overhead

---

## Async Completion

### When to Use

- Human-in-the-loop approvals
- Webhook-based integrations
- Long-polling external systems
- Batch jobs completed by external processes

### How It Works

1. Activity saves `TaskToken` from `activity.GetInfo(ctx)`
2. Activity returns `activity.ErrResultPending`
3. Temporal keeps activity "running" indefinitely
4. External process calls `client.CompleteActivity(ctx, token, result, err)` or `client.CompleteActivityByID()`

### Design Guidelines

- **Token Storage**: Store task token durably (database, queue) with correlation ID
- **Expiration**: Task tokens don't expire; track externally if needed
- **Failure Handling**: Call `CompleteActivity` with error to trigger retry logic
- **Cleanup**: Handle cases where completion never arrives (workflow cancellation)

### Heartbeat During Async

Activities waiting for external completion should heartbeat periodically to indicate they're still tracking the external operation, especially if timeouts are configured.

---

## Idempotency

### Why Critical

Activities may execute multiple times due to:
- Worker crash and retry
- Explicit retry from retry policy
- Workflow reset or replay

### Idempotency Key Sources

| Source | Best For |
|--------|----------|
| `WorkflowID + ActivityID` | Unique per activity instance |
| `WorkflowID + ActivityID + Attempt` | Distinguish retry attempts |
| `WorkflowExecution.RunID + ActivityID` | Unique within workflow run |
| Business key from input | Domain-specific deduplication |

Access via `activity.GetInfo(ctx)`.

### Patterns

**Check-then-Execute**: Query for existing result before performing action. Works when external system supports idempotent lookup.

**Upsert**: Use database upsert/merge operations. Works for state persistence.

**Idempotency Key Header**: Pass idempotency key to external APIs that support it (Stripe, payment processors).

**Outcome Recording**: Store activity outcome in external system; check on retry.

### Guidelines

- Build idempotency into activity design from the start
- Consider what "same result" means for your operation
- Handle partial completion (started but not finished)
- Test retry scenarios explicitly

---

## Error Handling

### Error Classification

| Return | Behavior | Use When |
|--------|----------|----------|
| `nil` | Success | Operation completed |
| `error` (any) | Retry | Transient failure; may succeed on retry |
| `temporal.NewNonRetryableApplicationError()` | Fail immediately | Permanent failure; retry won't help |
| `temporal.NewApplicationError()` | Configurable | Custom error types with optional retry |

### Non-Retryable Scenarios

- Input validation failures
- Resource not found (404)
- Permission denied (403)
- Business rule violations
- Data integrity errors

### Retryable Scenarios

- Network timeouts
- Rate limiting (429)
- Service unavailable (503)
- Connection reset
- Temporary resource contention

### Error Details Pattern

Attach structured details to errors for workflow-side decision making:
- Create custom error type with relevant fields
- Pass as detail argument to `NewApplicationError`
- Extract in workflow via `appErr.Details(&details)`

### Guidelines

- Classify errors explicitly; don't rely on default retry
- Include enough context for debugging
- Consider downstream impact of retries
- Log errors with activity context for correlation

---

## Activity Organization

### Struct-Based Activities

Group related activities in a struct for:
- Shared dependencies (clients, configs)
- Cleaner dependency injection
- Method-based registration
- Type-safe workflow references

### Registration

- `w.RegisterActivity(activityStruct)`: Registers all exported methods
- `w.RegisterActivityWithOptions()`: Custom names, aliases
- Method names become activity names by default

### Workflow References

Reference struct methods via nil pointer for compile-time type safety:
```
var activities *PaymentActivities // nil is fine
workflow.ExecuteActivity(ctx, activities.Charge, input)
```

### Guidelines

- One struct per bounded context or service integration
- Inject clients/configs via struct fields, not globals
- Keep activity methods focused; one external operation per method
- Use consistent naming: `VerbNoun` (e.g., `ProcessPayment`, `SendNotification`)
