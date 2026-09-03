# ADR Format

ADRs record decisions that future agents or maintainers would otherwise re-litigate.

Default location: `docs/adr/`. Create it lazily when the first ADR is needed.

Default naming: sequential files like `0001-use-postgres-for-read-model.md`. Scan existing files, increment the highest number, and use a short slug.

## Template

```md
# {Short title of the decision}

{1-3 sentences: what was the context, what did we decide, and why.}
```

That's enough for most decisions. The value is in recording that a decision was made and why.

## Optional sections

Only include these when they add genuine value:

- **Status**: `proposed`, `accepted`, `deprecated`, or `superseded by ADR-NNNN`.
- **Considered Options**: only when rejected alternatives are worth remembering.
- **Consequences**: only when non-obvious downstream effects matter.

## When to offer an ADR

Offer an ADR only when all three are true:

1. **Hard to reverse** — changing later would be meaningfully expensive.
2. **Surprising without context** — a future reader would wonder why this path was chosen.
3. **A real trade-off** — credible alternatives existed and one was chosen for specific reasons.

Skip ADRs for easy-to-reverse choices, obvious choices, temporary priorities, or implementation notes that belong in code.

## Good ADR subjects for Go projects

- Package or module ownership and seams.
- Persistence, messaging, or deployment technology choices.
- Concurrency model choices that affect correctness.
- Public interface shape for a package intended to be reused.
- Boundary decisions between domains or subsystems.
- Non-obvious deviations from idiomatic Go.
- Constraints invisible in code, such as compliance, latency, operational, or migration constraints.
