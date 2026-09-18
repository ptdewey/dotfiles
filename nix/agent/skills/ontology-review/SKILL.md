---
name: ontology-review
description: Review a codebase or named subsystem for conceptual-model coherence. Use when the user wants an ontology, domain-model, terminology, concept-boundary, or ubiquitous-language review. Produces a read-only, evidence-backed diagnosis and compact provisional model without modifying code or documentation.
---

# Ontology Review

Review the conceptual model expressed by a codebase: its domain concepts, terminology, identities, lifecycles, relationships, invariants, and boundaries.

This is not a general code-quality review, naming-style review, or formal RDF/OWL ontology validation.

## Scope

Review the whole repository or the subsystem, package, service, or domain area requested by the user.

Inspect neighboring areas when needed to understand boundaries and translations, but do not silently expand the requested scope.

For large repositories, inspect representative entry points and central artifacts systematically rather than claiming exhaustive coverage.

## Process

### Gather evidence

Inspect relevant:

- Domain and architecture documentation
- Central types and interfaces
- APIs and serialization contracts
- Database schemas and persistence models
- Commands, events, and state transitions
- Tests, fixtures, and error messages
- Package, module, and service boundaries

Do not treat any one artifact as automatically authoritative when artifacts disagree.

### Reconstruct the model

Identify the central:

- Concepts and their meanings
- Identities and value-like concepts
- Roles and lifecycle states
- Events, commands, and policies
- Relationships, ownership, and cardinality
- Invariants and state transitions
- Conceptual boundaries and translation points

Focus on concepts important to understanding or changing the system, not every identifier in the repository.

Trace representative identities, lifecycle transitions, and boundary crossings through actual code paths, not just declarations or names. Distinguish declared invariants from enforced ones.

### Diagnose conceptual problems

Look for:

- One term or type representing several concepts
- Several terms or types representing the same concept without justification
- Important domain concepts lacking explicit representation
- Code concepts with no clear domain meaning
- Confusion between identity, role, state, event, command, and value
- Unclear or contradictory ownership, lifecycle, cardinality, or invariants
- Context-specific models leaking across boundaries
- Implicit or inconsistent translation between contexts
- Contradictions among code, APIs, schemas, tests, and documentation
- Generic technical language obscuring important domain distinctions

Different terminology in different conceptual contexts is not inherently a defect. Judge coherence within a context and clarity at its boundaries.

Do not report naming preferences unless they materially change how the model is understood.

## Evidence discipline

Ground every finding in concrete files, symbols, schemas, or behaviors. Separate:

- **Observation:** what the repository demonstrably expresses
- **Interpretation:** what conceptual problem that evidence suggests
- **Impact:** why the distinction matters
- **Confidence:** high, medium, or low

Before reporting a finding, make a focused check of relevant callers, translations, tests, or documented rationale for evidence that explains the apparent inconsistency. Revise or discard it only when concrete evidence warrants it; hypothetical explanations are not counterevidence. Stop when further inspection is unlikely to change the conclusion, and state any remaining uncertainty.

Continue autonomously where evidence permits; ask only when unresolved uncertainty blocks a material conclusion.

The reconstructed model is provisional. Do not claim that repository evidence alone establishes objective domain truth.

## Severity

- **High:** conflicting concepts may cause incorrect behavior, data, or integration.
- **Medium:** ambiguity materially impedes maintenance or safe evolution.
- **Low:** localized conceptual inconsistency with limited operational effect.

## Output

Present the review in chat with these sections:

### Scope

What was requested, inspected, excluded, and any coverage limitations.

### Diagnosis

A concise overall assessment of conceptual coherence.

### Findings

Order findings by severity and impact. Use the fields defined under Evidence discipline, plus severity, evidence with file paths and symbols, and a brief follow-up direction. If no material issues are supported, say so rather than inventing findings.

A follow-up direction identifies whether the issue likely needs terminology, documentation, model, boundary, or implementation work. It is not a refactoring plan.

### Provisional model

Summarize the reconstructed model compactly, distinguishing evidence from inference.

## Constraints

- Remain read-only, except to write a report explicitly requested by the user to a destination they provide or approve.
- Do not perform follow-up work as part of the review.
- Do not assume any repository-specific documentation convention.
