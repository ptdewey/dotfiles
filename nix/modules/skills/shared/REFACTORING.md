# Go Refactoring Candidates

After behavior is covered by tests, look for improvements that increase depth, locality, and leverage.

## Candidates

- Shallow packages that mostly forward calls.
- Duplicated orchestration across handlers, commands, or workers.
- Large exported surfaces with little hidden behavior.
- Interfaces beside their only implementation.
- Helper packages named `util`, `common`, `misc`, or `manager`.
- Global mutable state.
- Error handling without context or stable semantics.
- Context cancellation not propagated through calls.
- Goroutine lifecycles that callers cannot stop.
- Tests that require excessive setup or generated mocks.

## Safe sequence

1. Get tests green.
2. Move behavior behind a clearer package/type/function seam.
3. Shrink the exported surface.
4. Keep compatibility or update callers in small steps.
5. Run focused tests after each step.
6. Run `go test ./...` before finishing.
7. Use `go test -race ./...` when concurrency changed.
