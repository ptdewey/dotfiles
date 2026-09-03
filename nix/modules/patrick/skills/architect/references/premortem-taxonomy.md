# Premortem taxonomy

Gary Klein premortem, Shreyas-Doshi flavor. Two passes: **generate** risks, then **verify** each against the spec/code before reporting.

## The four categories

### 🐅 Tigers — real, high-impact, likely

Things that will actually hurt you on the plausible path. Must be mitigated before shipping, or the decision itself reconsidered.

### 🐘 Elephants — real, high-impact, obvious-but-ignored

The big thing nobody's talking about. Often organizational: team capacity, on-call burden, compliance timeline, a migration that's been punted three times.

### 🐯 Paper Tigers — scary-looking, not real

The risk that sounds serious but, on inspection, can't actually happen in this system, or its blast radius is tiny. Name them explicitly so they stop consuming airtime.

### 🚨 False Alarms — risks that are real elsewhere but not here

A valid concern in general — but this context (scale, team, constraints) neutralizes it. Document *why* it's neutralized so future reviewers don't re-raise it.

## Per-risk format

```
- [severity: H/M/L] [category: Tiger|Elephant|Paper|False-alarm] <one-sentence risk>
  why: <mechanism — how this actually breaks>
  detect: <what metric, log, or signal would show it>
  mitigate: <action or "accept — reason">
  mitigation_checked: y/n
```

`mitigation_checked: n` means the risk is *open*. Shipping with open Tigers or Elephants requires explicit user decision.

## Two-pass protocol

1. **Generate** — brainstorm 8–15 risks across categories. Don't filter yet.
2. **Verify** — for each, check against the actual code, spec, or prior ADRs. Demote to Paper Tiger / False Alarm if the mechanism doesn't hold. Promote if you find a second mechanism.

Report only verified risks. Show the count of demoted ones as a sanity check (e.g. "12 generated → 7 verified, 3 Paper Tigers, 2 False Alarms").

## Common real risks by category

**Tigers for Temporal systems**
- Non-determinism introduced by a seemingly-safe refactor, bricks in-flight workflows on deploy.
- History size overrun on a long-running workflow, forces emergency Continue-as-New.
- Missing idempotency key on a side-effecting activity, double-charges on retry.

**Elephants for Go microservices**
- `ctx` not propagated into a library you don't control → unbounded work on SIGTERM.
- Single shared DB instance behind "microservices" → coupling through data, not code.
- No replay test suite in CI → determinism bugs land in prod.

**Paper Tigers commonly raised**
- "What if Kafka is down?" when the call path doesn't touch Kafka.
- "What about thundering herd on cache miss?" when QPS is 5.

**False Alarms commonly raised**
- "Eventual consistency will confuse users" — true at Facebook scale, not at 50 RPS with sticky sessions.
- "Generics will slow us down" — measured overhead is typically negligible for the shapes in question.
