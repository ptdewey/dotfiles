---
name: to-issues
description: Break a plan, spec, or PRD into independently grabbable implementation issues using tracer-bullet vertical slices. Use when the user wants to convert a plan into implementation issues.
---

# To Issues

Break a plan into independently grabbable issues using vertical slices.

If an issue tracker is configured or obvious, publish there after user approval. Otherwise create markdown issues under `.scratch/issues/` and tell the user the paths.

## Process

### 1. Gather context

Work from conversation context. If the user passes an issue reference, URL, or path, fetch/read the full body and comments if possible.

### 2. Explore the codebase

Explore enough to understand the current state. Use project vocabulary from `CONTEXT.md` when present, and respect ADRs in the area being changed.

For Go projects, identify relevant packages, exported seams, commands, handlers, workers, stores, adapters, migrations, and tests.

### 3. Draft vertical slices

Break the plan into tracer-bullet issues. Each issue should be a thin vertical slice through the required layers/endpoints/packages, not a horizontal “only schema” or “only tests” slice.

Slices may be:

- **HITL** — requires human interaction, architectural decision, design review, credential, or product call.
- **AFK** — can be implemented and verified by an agent without further human interaction.

Prefer AFK where possible.

<vertical-slice-rules>

- Each slice delivers a narrow but complete path.
- A completed slice is demoable or verifiable on its own.
- Prefer many thin slices over few thick ones.
- Include tests with the slice, not as a separate horizontal testing issue unless test infrastructure itself is the feature.

</vertical-slice-rules>

### 4. Quiz the user

Present the breakdown as a numbered list. For each slice, show:

- **Title**
- **Type**: HITL / AFK
- **Blocked by**
- **User stories covered** when known
- **Go seams touched**: packages/interfaces/commands/handlers at a high level

Ask whether the granularity, dependencies, and HITL/AFK markings are right. Iterate until approved.

### 5. Publish issues

Publish approved issues in dependency order so blockers can be referenced by real identifiers or paths.

Use project labels only when known. Do not close or modify parent issues unless explicitly asked.

<issue-template>

## Parent

Reference to the parent issue if one exists. Omit otherwise.

## What to build

A concise description of the vertical slice and end-to-end behavior.

Avoid fragile file-path-level instructions unless necessary. Prefer package/interface behavior over exact implementation steps.

## Go notes

- Public seam:
- Error/cancellation behavior:
- Adapter/test strategy:

Remove this section if not relevant.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- Reference blockers, or say “None — can start immediately.”

</issue-template>
