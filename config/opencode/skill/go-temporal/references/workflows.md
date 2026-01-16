# Workflow Patterns

## Table of Contents

- [Child Workflows](#child-workflows)
- [Continue-As-New](#continue-as-new)
- [Workflow Versioning](#workflow-versioning)
- [Saga Pattern](#saga-pattern)
- [Parallel Execution](#parallel-execution)
- [Timers and Deadlines](#timers-and-deadlines)
- [Cancellation Handling](#cancellation-handling)
- [Signals and Queries](#signals-and-queries)
- [Update Handlers](#update-handlers)

---

## Child Workflows

### When to Use

- Decompose complex workflows into manageable units
- Apply different retry/timeout policies to subprocesses
- Limit history size by isolating work (each child has its own history)
- Reuse workflow logic across different parent workflows

### Key Concepts

- Child workflows have independent retry policies and timeouts
- Parent-child relationship affects lifecycle via `ParentClosePolicy`:
  - `ABANDON`: Child continues if parent completes/fails
  - `TERMINATE`: Child terminated immediately if parent ends
  - `REQUEST_CANCEL`: Cancel signal sent to child (default)
  - `WAIT_CANCELLATION_COMPLETED`: Wait for child to handle cancellation

### Patterns

**Fire-and-Forget**: Start child without waiting for result. Parent continues immediately. Use for background processing or notifications.

**Orchestration**: Parent waits for child results. Use for breaking down complex business processes into stages.

**Dynamic Dispatch**: Select child workflow type based on runtime conditions. Useful for handling different entity types or processing strategies.

---

## Continue-As-New

### When to Use

- Workflows processing unbounded streams of events
- Long-running workflows approaching 10K-50K history events
- Periodic workflows that run indefinitely (cron-style)
- Any workflow that accumulates state over time

### Key Concepts

- Restarts workflow with fresh history while preserving logical continuity
- Pass forward only the state needed for the next execution
- Check `workflow.GetInfo(ctx).GetCurrentHistoryLength()` to decide when to continue
- All pending activities complete before new execution starts

### Design Guidelines

- **Threshold**: Continue-as-new at ~5,000-10,000 events (well before 50K limit)
- **State Serialization**: Only pass essential state; large state defeats the purpose
- **Signals**: Pending signals transfer to new execution automatically
- **Child Workflows**: Complete or handle appropriately before continuing

---

## Workflow Versioning

### When to Use

- Modifying logic in workflows that have running executions
- Adding new steps to existing workflow definitions
- Changing activity execution order or parameters

### Key Concepts

`workflow.GetVersion(ctx, changeID, minSupported, maxSupported)`:
- Returns version number for this execution
- Existing executions continue with their original version
- New executions use the max version
- Versions are per-changeID (multiple independent changes allowed)

### Version Lifecycle

1. **Add Change**: `GetVersion(ctx, "my-change", DefaultVersion, 1)` - existing workflows get DefaultVersion, new get 1
2. **Deprecate Old**: Once all old executions complete, change to `GetVersion(ctx, "my-change", 1, 1)`
3. **Remove Versioning**: After stabilization, remove GetVersion call entirely

### Guidelines

- Use descriptive changeIDs: `"add-validation-step"`, `"change-retry-policy"`
- Never modify code inside a version branch without bumping version
- Independent changes get independent changeIDs
- Version at the smallest scope possible

---

## Saga Pattern

### When to Use

- Multi-step transactions across distributed systems
- Operations that need rollback on partial failure
- Coordinating actions with different failure domains

### Key Concepts

- Each forward action has a corresponding compensation action
- On failure, execute compensations in reverse order
- Compensations should be idempotent (they may also retry)

### Design Guidelines

- **Compensation Design**: Compensations must handle cases where the forward action:
  - Completed successfully
  - Partially completed
  - Never executed (earlier step failed)
  
- **Ordering**: Stack compensations in reverse order of forward actions

- **Failure in Compensation**: Log and continue with remaining compensations. Don't let one failed compensation stop others.

- **Parallel Compensations**: Consider parallel execution for independent compensations to reduce rollback time.

---

## Parallel Execution

### Patterns

**Fan-Out/Fan-In**: Launch multiple activities concurrently, wait for all results. Use when operations are independent and you need all results.

**Bounded Parallelism**: Limit concurrent operations with `workflow.Semaphore`. Prevents overwhelming downstream services or exceeding rate limits.

**Race/First-Wins**: Use `workflow.Selector` to act on first completion. Useful for timeout patterns, hedged requests, or fastest-wins scenarios.

### Guidelines

- Use `workflow.Go()` for concurrent work within workflows
- Protect shared state with `workflow.Mutex`
- Collect errors from all branches; don't fail fast unless appropriate
- Consider downstream service capacity when choosing parallelism level

---

## Timers and Deadlines

### Use Cases

- Scheduled reminders or follow-ups
- Timeout patterns (approval workflows, SLA enforcement)
- Rate limiting within workflows
- Periodic polling with backoff

### Key APIs

- `workflow.Sleep(ctx, duration)`: Pause execution for duration
- `workflow.NewTimer(ctx, duration)`: Create timer future for selector-based patterns
- `workflow.WithDeadline(ctx, time)`: Set absolute deadline for context

### Patterns

**Timer with Signal Race**: Wait for either a signal or timeout, whichever comes first. Common for approval workflows.

**Workflow-Level Deadline**: Set deadline context for entire workflow or section. All operations within must complete before deadline.

**Progressive Backoff**: Increase sleep duration between retries within workflow logic.

---

## Cancellation Handling

### Key Concepts

- Cancellation is cooperative; workflows must check for it
- Use `workflow.NewDisconnectedContext(ctx)` for cleanup that must run regardless
- Activities should check `ctx.Err()` periodically

### Patterns

**Graceful Shutdown**: Detect cancellation, complete current unit of work, run cleanup in disconnected context.

**Compensation on Cancel**: Treat cancellation like failure in saga patterns; run compensations before returning.

**Propagation Control**: Choose whether child workflows receive cancellation via `ParentClosePolicy`.

### Guidelines

- Always plan for cancellation in long-running workflows
- Keep cleanup operations bounded in time
- Log cancellation events for debugging
- Consider whether partial work should be rolled back

---

## Signals and Queries

### Signals

Async messages to running workflows. Use for:
- External events (approvals, webhooks)
- Workflow coordination
- State updates from outside

**Design Guidelines**:
- Signals are fire-and-forget; sender doesn't wait for processing
- Workflows must handle signals at any point in execution
- Use typed signal channels with clear schemas
- Consider signal ordering and deduplication

### Queries

Synchronous read of workflow state. Use for:
- Status checks and monitoring
- Progress reporting
- State inspection without affecting execution

**Design Guidelines**:
- Queries must not modify workflow state
- Keep query handlers fast; they block the workflow
- Return serializable data structures
- Register handlers early in workflow execution

---

## Update Handlers

### When to Use

- Synchronous state modifications with validation
- Operations requiring acknowledgment of completion
- Interactive workflow modifications

### Key Concepts

- Updates have optional validator (runs before acceptance)
- Handler runs after validation, can modify state
- Caller waits for handler completion
- Failed validation rejects update without state change

### Guidelines

- Use validators for input validation and precondition checks
- Keep handlers deterministic (same rules as workflow code)
- Return meaningful results to caller
- Consider update ordering with concurrent requests
