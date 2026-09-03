# CONTEXT.md Format

A `CONTEXT.md` file captures project-specific language: canonical terms, relationships, and rejected synonyms that agents should use when discussing or changing the project.

It is a glossary, not a spec, implementation plan, scratch pad, or decision log. Keep implementation details in code, PRDs, issues, or ADRs instead.

## Structure

```md
# {Context Name}

{One or two sentences describing this context and why it exists.}

## Language

**Canonical Term**:
One or two sentences defining what the term is.
_Avoid_: AmbiguousTerm, LegacyTerm, NearSynonym

## Relationships

- **Thing A** owns **Thing B**
- **Thing C** depends on **Thing D**

## Flagged ambiguities

- “Foo” has been used to mean both X and Y. Prefer X for ..., and Y for ...
```

## Rules

- Define project/domain concepts only. General Go or programming concepts do not belong here.
- Be opinionated: when several words exist for the same concept, pick one canonical term.
- Keep definitions tight: one or two sentences max.
- Use `_Avoid_` for synonyms, legacy names, or words that caused confusion.
- Capture ambiguity explicitly when a term is overloaded.
- Update the file as terminology crystallizes during design work.

## Single vs multi-context repos

**Single context:** prefer one `CONTEXT.md` at the repo root.

**Multiple contexts:** use a root `CONTEXT-MAP.md` that points to each context file:

```md
# Context Map

## Contexts

- [Ordering](./internal/ordering/CONTEXT.md) — receives and tracks customer orders
- [Billing](./internal/billing/CONTEXT.md) — generates invoices and records payments

## Relationships

- **Ordering → Billing**: Ordering emits events that Billing consumes.
```

Inference rules:

- If `CONTEXT-MAP.md` exists, read it to find the relevant context.
- If only a root `CONTEXT.md` exists, use it.
- If neither exists, create a root `CONTEXT.md` lazily when the first term is resolved.
- If multiple contexts exist and the relevant one is unclear, ask.
