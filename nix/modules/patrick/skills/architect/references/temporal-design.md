# Temporal design reference

Load when `go.temporal.io/sdk` is in `go.mod` or workflow/activity code is present. This is the highest-value reference file in this skill.

## Determinism rules (workflow code)

Workflow code may call **only** `workflow.*` for time, timers, sleep, rand, IO, and concurrency. Flag in critique:

| Forbidden in workflow | Replacement |
|-----------------------|-------------|
| `time.Now` | `workflow.Now(ctx)` |
| `time.Sleep` | `workflow.Sleep(ctx, d)` |
| `time.After` | `workflow.NewTimer(ctx, d)` |
| `math/rand`, `crypto/rand` | `workflow.SideEffect` |
| native `go func()` | `workflow.Go` |
| native `chan` | `workflow.Channel` |
| native `select` | `workflow.Selector` |
| `range map` (iteration order) | sort keys, then iterate |
| `http.*`, `os.*`, file IO, DB | move to an **Activity** |
| package-global mutable state | don't |
| `log.Printf` / `slog.*` | `workflow.GetLogger(ctx)` |

**Static check:** `contrib/tools/workflowcheck` catches many of these at compile time. Add to CI.

**Replay test suite:** `worker.NewWorkflowReplayer().ReplayWorkflowHistoryFromJSONFile(...)` — ship representative production histories in-repo and replay on every PR. Catches non-determinism before deploy.

## Versioning decision tree

```
small in-flight-safe logic change
  → workflow.GetVersion("change-id", minSupported, maxSupported)
     with a branch per history range.

large structural change (new signals, removed activities, reshaped state)
  → Worker Versioning / Worker Deployment Versions,
     progressive rollout via the Temporal Worker Controller on K8s.

history hygiene (long-running workflow, growing history)
  → Continue-as-New at a safe boundary.
     Drain pending signals first.
```

Never "just deploy and hope." Always add the new history variant to the replay test suite.

## Timeout semantics (memorize)

| Timeout | Meaning | When |
|---------|---------|------|
| `StartToClose` | max per attempt | **Always set.** Detects worker crash. |
| `ScheduleToClose` | total cap including retries | Only meaningful when `MaxAttempts > 1`. |
| `ScheduleToStart` | max in task queue before pickup | Rarely set; prefer monitoring `schedule_to_start_latency`. |
| `Heartbeat` + `HeartbeatTimeout` | liveness signal | **Required** for anything >few seconds. Enables cancellation delivery and crash detection. |
| Workflow Task Timeout | default 10s | Don't block workflow code; SDK deadlock detector trips at 1s. |

## Activity design rules

- **Idempotent by construction.** Require an idempotency key in the activity input struct for any side-effecting activity. "Already exists" on create and "not found" on delete are both successes.
- **Heartbeat** anything non-trivially long. Include progress in the heartbeat payload for resumability.
- **Payload limits:**
  - 2 MB per activity arg/return
  - 4 MB per transaction
  - 50 MB per workflow history (hard limit)
  - Plan Continue-as-New around **10k events / 10 MB**
- **Large blobs** → S3/GCS, pass the URL.
- **One input struct, one output struct.** Version by field addition.
- **Granular > monolithic.** A failed sub-step shouldn't require re-running the whole activity.

## Retry policy discipline

- Default: unlimited attempts, 1s initial, 2.0 backoff. Tune for failure model.
- Mark domain errors **non-retryable**: `temporal.NewNonRetryableApplicationError(...)` or `NonRetryableErrorTypes` — validation failures, auth errors, card declined, 4xx from external APIs.
- **Workflows** usually don't need a retry policy. Transient failures belong on activities.

## Signal / Query / Update decision matrix

| Need | Use |
|------|-----|
| Mutation + you need the result | **Update** (or Update-with-Start for upsert) |
| Fire-and-forget external event | **Signal** |
| Read-only state access | **Query** |
| "Create or mutate" in one call | **Update-with-Start** |

Default new designs to **Update** over the Signal+Query polling anti-pattern.

## Child workflow vs activity

**Default: activity.** Child workflow only when at least one of:

1. Separate event history for partitioning / history-size budget.
2. Separate lifecycle / task queue / owning team.
3. Workflow-ID uniqueness needed as a resource lock.
4. Workflow primitives (timers, signals, queries) required inside the subtask.

**Do NOT** use child workflows for mere code organization. They cost more and inflate history.

## Saga / compensation

- Track compensations as you go; invoke **LIFO** on failure.
- Do **not** set tight workflow timeouts or `MaxAttempts=1` on the parent — compensations may not run.
- Avoid `terminate` / `reset` — they skip `defer`.
- Prefer **forward recovery** where safe; **compensating actions** where not.

## Deployment posture (K8s/AWS)

- Workers are long-poll gRPC clients. **Lambda is a bad fit.** ECS Fargate for small fleets; **EKS recommended** at scale.
- One Deployment per task queue.
- Autoscale on **task-queue backlog** or `schedule_to_start_latency`, not CPU.
- SIGTERM → graceful `worker.Stop()` → drain in-flight activities respecting heartbeat timeouts.
- Use the official **Temporal Worker Controller** for versioned rainbow deploys.

## Sharp Temporal questions

- "What happens if this activity partially succeeds, the worker crashes, then it retries?"
- "Is every side-effecting activity keyed by an idempotency token?"
- "Which errors here are non-retryable, and where is that enforced?"
- "How does this workflow behave during a rolling deploy mid-execution — `GetVersion`, Worker Versioning, or praying?"
- "What's your plan when this workflow's history exceeds 10k events?"
- "Why is this a Signal and not an Update?"
- "Draw the compensation for every forward step — which are missing a reverse?"
- "If this workflow is terminated mid-saga, what state is the world in?"
- "How does a worker pod SIGTERM drain without losing heartbeats?"
- "Which metric triggers autoscaling — backlog, CPU, or schedule-to-start latency?"
- "Where are you calling `time.Now` / `rand` / `http.*` inside workflow code?"
- "Is this `StartToClose` or `ScheduleToClose`, and why?"
- "Does this payload ever exceed 2 MB under real load?"

## Cart/checkout domain specifics

- **Cart as workflow** keyed by `cart:{userId}`; items added via **Update** (validates stock, returns result); cart TTL via `workflow.NewTimer`.
- Checkout signals a child workflow or Continue-as-New into an order workflow.
- **Inventory model:**
  - *Pessimistic* — reserve-on-add, TTL'd hold, release on abandon. Strong consistency, worse conversion.
  - *Optimistic* — check-only at add, reserve at checkout, compensate on oversell. Higher throughput, compensation path mandatory.
- **Payment saga:** reserve inventory → authorize → capture → decrement → fulfill. Each step needs a compensation.
