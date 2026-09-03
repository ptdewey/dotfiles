---
name: improve-codebase-architecture
description: Find Go codebase deepening opportunities informed by CONTEXT.md and ADRs. Use when the user wants to improve architecture, find refactoring opportunities, consolidate shallow packages, or make a codebase more testable and agent-navigable.
---

# Improve Go Codebase Architecture

Surface architectural friction and propose **deepening opportunities**: refactors that turn shallow modules into deep ones. The aim is testability, locality, leverage, and agent navigability.

Use the vocabulary in `shared/ARCHITECTURE-LANGUAGE.md` from the installed skills root next to this skill. This skill is informed by the project's domain model in `CONTEXT.md` and decisions in `docs/adr/`.

## Process

### 1. Explore

Read project language and ADRs first when present:

- `CONTEXT.md`
- `CONTEXT-MAP.md`
- `docs/adr/`

Then explore the Go codebase. Use available search, build, test, and subagent tools as appropriate. Do not follow rigid heuristics; note where understanding or testing becomes difficult.

Look for:

- Packages with wide exported surfaces and little hidden behavior.
- Interfaces defined beside their only implementation.
- `service`, `repository`, `manager`, `util`, `common`, or `helper` packages with unclear cohesion.
- Duplicated orchestration across handlers, commands, workers, or tests.
- Callers that must know SQL shape, retry behavior, ordering rules, or concurrency details.
- Context cancellation/deadline behavior that is missing or hidden.
- Goroutine lifecycles that are hard to stop or test.
- Global mutable state.
- Tests that require excessive mocks or setup.
- Shallow adapters that simply rename another package.
- Package cycles, near-cycles, or imports that reveal misplaced ownership.
- `any`, reflection, or generics where ordinary Go types would be clearer.

Apply the deletion test to suspected shallow modules: would deleting the module concentrate complexity, or merely move it to callers?

### 2. Present candidates as an HTML report

Write a self-contained HTML file to the OS temp directory. Use `shared/HTML-REPORT.md` from the installed skills root next to this skill for the report format.

Each candidate card must include:

- **Files/packages** involved.
- **Problem** causing friction.
- **Solution** in plain English.
- **Benefits** in terms of locality, leverage, and testability.
- **Before / After diagram** showing how the exported surface or seam changes.
- **Recommendation strength**: `Strong`, `Worth exploring`, or `Speculative`.

Use `CONTEXT.md` vocabulary for domain concepts and architecture vocabulary for module/interface/seam language.

If a candidate conflicts with an ADR, surface it only when the friction is real enough to justify revisiting the ADR.

Do not propose final interfaces yet. After writing and opening the report, ask: “Which of these would you like to explore?”

### 3. Grilling loop

Once the user picks a candidate, switch into a grilling conversation:

- What should the deepened module own?
- Where should the seam live?
- What exported surface should callers see?
- What implementation details move behind the seam?
- Which adapters are real?
- What error semantics matter?
- How should `context.Context` cancellation/deadlines flow?
- What concurrency guarantees are required?
- Which tests should survive future refactors?

Side effects happen inline as decisions crystallize:

- If a new domain term is chosen, update `CONTEXT.md` using `shared/CONTEXT-FORMAT.md` from the installed skills root next to this skill.
- If the user rejects a candidate for a durable reason, offer an ADR using `shared/ADR-FORMAT.md` from the installed skills root next to this skill.
- If the user wants alternative interface designs, use `shared/INTERFACE-DESIGN.md` from the installed skills root next to this skill and compare designs by depth, locality, and seam placement.

## Output discipline

- Be visual first in the report, conversational afterward.
- Use Go vocabulary naturally: package, exported surface, unexported implementation, constructor, method set, context, error semantics.
- Avoid proposing abstraction for its own sake.
- Prefer concrete types until variation proves a seam is real.
