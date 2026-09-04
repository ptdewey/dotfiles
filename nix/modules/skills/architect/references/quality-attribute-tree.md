# Quality-attribute utility tree (ATAM-lite)

Fill this out in Phase 1. A quality attribute without a *scenario* is a wish; a scenario without *(importance, difficulty)* tagging is noise.

## Format

```
<Attribute>
  └── <Scenario — stimulus, environment, response, response measure>
        (importance: H/M/L, difficulty: H/M/L)
```

Tag each leaf with two letters: `(H,H)` = critical and hard = focus here. `(L,L)` = not worth architectural spend.

## Template

```
Performance
  ├── Latency: 95% of cart-add requests complete <150ms at 500 RPS peak.
  │     (importance: H, difficulty: M)
  ├── Throughput: sustain 1000 cart-mutations/sec with <1% error rate.
  │     (importance: M, difficulty: M)
  └── Tail: p99.9 <600ms during 2x burst.
        (importance: M, difficulty: H)

Availability
  ├── Uptime: 99.95% measured monthly, excluding planned maintenance.
  │     (importance: H, difficulty: M)
  ├── Graceful degradation: on inventory-service outage, cart remains usable in read-only mode.
  │     (importance: M, difficulty: M)
  └── Recovery: RTO 5 min, RPO 0 for committed orders.
        (importance: H, difficulty: H)

Consistency / correctness
  ├── No double-charge under retry storm.
  │     (importance: H, difficulty: M)
  └── Inventory never oversold beyond configured tolerance (0 for regulated SKUs).
        (importance: H, difficulty: H)

Operability
  ├── On-call can diagnose a stuck workflow within 10 minutes using standard dashboards.
  │     (importance: H, difficulty: M)
  ├── Deploys are zero-downtime for in-flight workflows.
  │     (importance: H, difficulty: H)
  └── A failed deploy can be rolled back within 15 min without data loss.
        (importance: H, difficulty: M)

Security
  ├── All PII encrypted at rest and in transit; access audited.
  │     (importance: H, difficulty: L)
  ├── Blast radius of a compromised worker credential: single task queue.
  │     (importance: H, difficulty: M)
  └── No secrets in workflow history payloads.
        (importance: H, difficulty: L)

Cost
  ├── Infra spend <$X/month at launch RPS.
  │     (importance: M, difficulty: L)
  └── Unit cost per order <$Y.
        (importance: M, difficulty: M)

Evolvability
  ├── Workflow versioning strategy survives 12+ months of in-flight workflows.
  │     (importance: H, difficulty: H)
  └── Adding a new activity to the saga doesn't require rewriting the parent.
        (importance: M, difficulty: M)
```

## Usage

- A scenario is **S**timulus + **E**nvironment + **R**esponse + **R**esponse-measure. "Fast" is not a scenario. "p95 <150ms at 500 RPS" is.
- Anything tagged `(H,H)` goes into the architecture discussion explicitly.
- Anything `(L,*)` can be deferred to implementation.
- If two scenarios conflict, name the tradeoff and pick in Phase 4.
