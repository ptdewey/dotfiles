---
status: "proposed"        # proposed | accepted | deprecated | superseded
date: {{DATE}}
deciders: [{{DECIDERS}}]
consulted: []
informed: []
---

# ADR-{{NNNN}}: {{TITLE}}

## Y-statement

In the context of **{{CONTEXT}}**, facing **{{NFR_OR_CONCERN}}**, we decided for **{{CHOSEN_OPTION}}** and against **{{REJECTED_OPTIONS}}** to achieve **{{BENEFITS}}**, accepting **{{DRAWBACKS}}**.

## Context and problem statement

<!-- 2–4 sentences. What forces are at play? What scenario triggers this decision? -->

## Decision drivers

- {{DRIVER_1}}
- {{DRIVER_2}}
- {{DRIVER_3}}

## Considered options

1. **{{OPTION_A}}** — one-line summary
2. **{{OPTION_B}}** — one-line summary
3. **{{OPTION_C}}** — one-line summary

## Decision outcome

**Chosen:** {{CHOSEN_OPTION}} — because {{JUSTIFICATION}}.

**Door type:** two-way | one-way
**Blast radius:** {{SCOPE}}

### Consequences

- ✅ **Good:** {{POSITIVE_1}}
- ✅ **Good:** {{POSITIVE_2}}
- ⚠️ **Bad:** {{NEGATIVE_1}}
- ⚠️ **Bad:** {{NEGATIVE_2}}

## Pros and cons of the options

### {{OPTION_A}}

- 👍 {{PRO}}
- 👎 {{CON}}

### {{OPTION_B}}

- 👍 {{PRO}}
- 👎 {{CON}}

### {{OPTION_C}}

- 👍 {{PRO}}
- 👎 {{CON}}

## Implementation plan (executable spec)

**Affected files / entry points:**
- `path/to/file.go:LINE` — {{ROLE}}
- `path/to/other.go:LINE` — {{ROLE}}

**Patterns to follow:**
- {{PATTERN}}

**Patterns to avoid:**
- {{ANTI_PATTERN}}

**Verification criteria (testable):**
- [ ] {{CRITERION_1}}
- [ ] {{CRITERION_2}}

**Code linkage:** add `// ADR-{{NNNN}}` comments at the governed call sites.

## Risks (premortem summary)

- 🐅 {{TIGER}} — mitigation: {{M}}
- 🐘 {{ELEPHANT}} — mitigation: {{M}}

## Links

- Supersedes: {{NONE_OR_ADR}}
- Related: {{ADRS}}
- Prior art: {{CITATIONS}}
