# Interrogation questions

Pull three-to-five high-yield questions per critique session. Filter by context (Go, Temporal, general). Ask **one at a time**.

## Scope and intent

- What does this explicitly *not* do? Name one capability you're deciding against.
- What's the smallest version of this that would still be useful in production?
- If you had to ship in 2 weeks instead of 2 months, what would you drop?

## Users and load

- Who's the first real caller? What's their expected RPS at launch and at 12 months?
- What's the p99 latency budget end-to-end? How much of that is network vs compute vs DB?
- What's the data volume at steady state — rows, bytes, events/sec?

## Quality attributes

- What's the availability target — 99.9, 99.99, best-effort? What's the cost of a minute of downtime?
- RPO and RTO — how much data can you lose, how fast must you recover?
- What's the cost ceiling per request, or per month?
- Which of {latency, availability, consistency, cost, simplicity} loses if two conflict?

## Data and state

- Who owns this data? Who else reads it? Who writes it?
- What's the consistency model — strong, read-your-writes, eventual?
- How is this data evolved over time — schema migrations, backfills, dual-writes?
- What happens on a partial write? A concurrent write?

## Failure modes

- What happens when the database is down for 5 minutes?
- What happens when a downstream dependency is slow (not failing, just slow)?
- What's the retry policy, and what protects downstreams from retry storms?
- Is there a circuit breaker, and what's its reset behavior?
- Where's the backpressure applied? What happens when the queue fills?

## Change and reversibility

- Is this a two-way door (reversible in a week) or one-way (committed for a year+)?
- How do you roll this back if it's wrong? What's the blast radius of the rollback?
- What's the migration path from the current state — big-bang, strangler, parallel-run, branch-by-abstraction?
- What parts of this become load-bearing public API once released (Hyrum's Law)?

## Team and operability

- Who pages at 3am when this breaks? Do they know the runbook?
- What metric tells you this is unhealthy *before* a user notices?
- What's the Conway's-Law fit — does the system boundary match a team boundary?
- What's the on-call cognitive load compared to the system we're replacing?

## Security

- What's the authN/authZ model? Where's the enforcement point?
- What PII touches this path? What's the retention policy?
- What's the blast radius of a compromised credential in this component?
- Who has production access, and what's the audit trail?

## Dependencies

- Which of these dependencies existed 3 years ago? Which will exist in 3 years?
- What's the fallback when the third-party dependency is down?
- Is there a Chesterton's fence in the current code — something that looks removable but isn't?

## Go-specific

See `go-heuristics.md` for the full catalog. Top 5 to pull in critique:

- "Does this interface have exactly one implementation? If so, why does it exist?"
- "Which goroutines here have no cancellation path?"
- "Where does `ctx` stop propagating?"
- "What's the zero value, and does it work?"
- "Which errors lose their wrap chain?"

## Temporal-specific

See `temporal-design.md` for the full catalog. Top 5 to pull in critique:

- "What happens if this activity partially succeeds, the worker crashes, then it retries?"
- "Is every side-effecting activity keyed by an idempotency token?"
- "How does this workflow behave during a rolling deploy mid-execution?"
- "Why is this a Signal and not an Update?"
- "Draw the compensation for every forward step — which are missing a reverse?"
