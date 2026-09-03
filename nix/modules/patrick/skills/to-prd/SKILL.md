---
name: to-prd
description: Turn the current conversation context into a PRD. Use when the user wants to synthesize a plan or feature discussion into a product requirements document.
---

This skill turns the current conversation context and codebase understanding into a PRD. Do not conduct a broad interview; synthesize what is already known. Ask only for essential missing information.

If an issue tracker is configured or obvious, publish there after confirmation. Otherwise write the PRD as markdown under `.scratch/prds/` and tell the user the path.

## Process

1. Explore the repo enough to understand current behavior. Use the project vocabulary from `CONTEXT.md` when present, and respect ADRs in the area being changed.

2. Sketch the major Go packages, commands, handlers, workers, stores, or adapters that may need to change. Look for opportunities to create deep modules with small exported surfaces that can be tested through public seams.

3. Check with the user that the package/module sketch matches expectations. Ask which behaviors matter most for tests.

4. Write the PRD using the template below. If publishing to an issue tracker, use the project’s configured “ready for agent” or equivalent label only when known; otherwise leave labeling to the user.

## Go implementation prompts

Consider whether the PRD needs to record:

- New or changed exported types/functions/methods.
- Package ownership and seams.
- Error semantics and sentinel/wrapped error expectations.
- `context.Context` cancellation/deadline behavior.
- Concurrency, goroutine lifecycle, or race-safety requirements.
- Persistence migrations or generated code.
- External adapters such as HTTP, gRPC, queues, filesystems, or clocks.
- Test strategy: unit, integration, `httptest`, test DB, fake adapter, race test, fuzz test.

<prd-template>

## Problem Statement

The problem from the user's perspective.

## Solution

The solution from the user's perspective.

## User Stories

A numbered list of user stories:

1. As an <actor>, I want <feature>, so that <benefit>.

## Implementation Decisions

Implementation decisions that were made, such as package/module changes, public interfaces, architectural decisions, schema changes, API contracts, error semantics, concurrency behavior, and technical clarifications.

Avoid specific file paths or code snippets unless a short prototype snippet captures a decision more precisely than prose.

## Testing Decisions

Testing decisions, including which behaviors to test, which public seams to test through, and similar prior tests in the codebase.

## Out of Scope

What this PRD intentionally excludes.

## Further Notes

Any additional context.

</prd-template>
