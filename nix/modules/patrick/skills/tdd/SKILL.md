---
name: tdd
description: Go-focused test-driven development with a red-green-refactor loop. Use when the user wants to build features or fix bugs test-first, mentions TDD or red-green-refactor, or wants integration-style Go tests.
---

# Go Test-Driven Development

## Philosophy

Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests should survive when behavior stays the same.

Good Go tests are often integration-style at the package or adapter seam: they exercise real code paths through exported functions, methods, handlers, commands, or small consumer-owned interfaces.

See `shared/TESTING.md`, `shared/MOCKING.md`, `shared/DEEP-MODULES.md`, `shared/INTERFACE-DESIGN.md`, and `shared/REFACTORING.md` in the installed skills root next to this skill.

## Anti-pattern: horizontal slices

Do not write all tests first, then all implementation. That outruns your headlights and produces tests for imagined behavior.

Correct approach: one behavior → one failing test → minimal implementation → green → repeat.

```txt
WRONG:
  RED:   test1, test2, test3, test4
  GREEN: impl1, impl2, impl3, impl4

RIGHT:
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
```

## Workflow

### 1. Planning

Before code changes:

- Identify the public Go seam to test: package function, method, handler, CLI, worker, or adapter interface.
- Confirm important behaviors with the user unless the change is small and obvious.
- Identify opportunities for deep modules: small exported surface, hidden implementation.
- Decide whether to use real dependencies, fakes, `httptest`, temp dirs, a test DB, or another adapter.
- Find the focused test command, usually `go test ./path/to/package`.

Ask: “What should the public seam look like, and which behaviors matter most?”

### 2. Tracer bullet

Write one test that confirms one behavior.

```txt
RED:   Write test for first behavior → test fails
GREEN: Write minimal code to pass → test passes
```

This proves the path works end to end.

### 3. Incremental loop

For each remaining behavior:

```txt
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

Rules:

- One test at a time.
- Only enough code to pass the current test.
- Do not anticipate future tests.
- Keep tests focused on observable behavior.
- Prefer table tests when one behavior has multiple input cases.

### 4. Refactor

After tests pass, refactor while staying green:

- Remove duplication.
- Deepen packages/modules.
- Shrink exported surfaces.
- Move complexity behind unexported implementation.
- Improve error context and cancellation behavior.
- Replace speculative interfaces with concrete types when variation is not real.

Never refactor while red.

## Commands

- Focused package: `go test ./internal/foo`
- All packages: `go test ./...`
- Race-sensitive changes: `go test -race ./...`
- Specific test: `go test ./internal/foo -run TestName`
- Fuzz targets: `go test ./internal/foo -fuzz FuzzName`

## Checklist per cycle

```txt
[ ] Test describes behavior, not implementation
[ ] Test uses the public seam
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] Errors/cancellation are covered when part of behavior
[ ] No speculative interfaces or features added
```
