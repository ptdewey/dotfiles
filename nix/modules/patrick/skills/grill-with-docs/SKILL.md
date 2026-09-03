---
name: grill-with-docs
description: Grilling session that challenges a plan against the codebase, sharpens terminology, and updates project documentation such as CONTEXT.md and ADRs as decisions crystallize. Use when the user wants to stress-test a design against project language and documented decisions.
---

<what-to-do>

Interview the user relentlessly about every aspect of the plan until you reach shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one by one. For each question, provide your recommended answer.

Ask one question at a time and wait for feedback before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

</what-to-do>

<supporting-info>

## Domain awareness

During codebase exploration, look for existing documentation:

- `CONTEXT.md` for project language.
- `CONTEXT-MAP.md` for multi-context repos.
- `docs/adr/` for prior decisions.

Create files lazily. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

Use `shared/CONTEXT-FORMAT.md` and `shared/ADR-FORMAT.md` from the installed skills root next to this skill.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with `CONTEXT.md`, call it out immediately: “Your glossary defines X as ..., but you seem to mean Y — which is it?”

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term.

### Discuss concrete scenarios

Stress-test relationships and edge cases with specific scenarios. Force precision around concept boundaries.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If code and plan conflict, surface the contradiction.

For Go projects, pay particular attention to package ownership, exported interfaces, error semantics, context cancellation, concurrency behavior, and persistence seams.

### Update CONTEXT.md inline

When a term is resolved, update the relevant `CONTEXT.md` immediately. Do not batch these updates.

`CONTEXT.md` should stay devoid of implementation details. It is a glossary and relationship map, not a spec.

### Offer ADRs sparingly

Only offer an ADR when the decision is hard to reverse, surprising without context, and the result of a real trade-off.

</supporting-info>
