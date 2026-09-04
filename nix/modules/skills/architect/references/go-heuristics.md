# Go heuristics

Load when the project contains `go.mod`. Use to drive sharp, Go-specific questions instead of generic "have you considered..." prompts.

## Proverbs to enforce

- **Accept interfaces, return structs.** Interfaces belong in the consumer package, not the producer (Cheney, *SOLID Go Design*).
- **Don't create an interface until you have ≥2 implementations or a genuine test-double need.** Single-impl interfaces next to their struct are premature abstraction.
- **The bigger the interface, the weaker the abstraction** (Pike). Flag any interface with >4 methods as suspect.
- **A little copying is better than a little dependency.**
- **Errors are values.** Wrap with `fmt.Errorf("...: %w", err)`; inspect with `errors.Is` / `errors.As`; assert for behavior, not concrete type.
- **`context.Context` is the first arg, never stored in structs, never nil, `defer cancel()` always.**
- **Generics only when the alternative is `interface{}` + reflection, or duplicated identical code across types.**
- **Functional options are overkill for <5 params** — prefer a config struct.
- **Make the zero value useful** — model on `sync.Mutex`, `bytes.Buffer`.
- **Don't communicate by sharing memory; share memory by communicating** — but mutexes are fine when protection is clearer than coordination.

## Anti-patterns to flag in critique mode

1. Premature interface with a single implementation.
2. Giant `Service` / `Repository` / `Manager` interface (>4 methods, grab-bag).
3. Shared mutable state without mutex *or* channel discipline.
4. Goroutine leaks — no `ctx` check, no `done` channel, orphan workers.
5. Naked channels with no documented ownership (who writes? who closes? who reads?).
6. Mutex where a channel is clearer, or vice versa — pick based on problem shape.
7. DI containers, `Manager` / `Helper` / `Util` packages (poor cohesion smell).
8. `internal/` misuse — exposing internals, or hiding things that should be exported.
9. Unbounded worker pools, `go func()` per request with no backpressure.
10. Missing `ctx` propagation into DB, HTTP, Temporal SDK calls.
11. `panic` / `recover` for control flow instead of errors.
12. Returning `any` / `interface{}` from domain APIs.
13. `log.Fatal` in library code.
14. `context.Context` stored in a struct field.
15. Unchecked `defer resp.Body.Close()` (ignoring the error, or missing entirely on error paths).

## Sharp Go questions to ask in critique mode

- "Does this interface have exactly one implementation? If so, why does it exist?"
- "Which goroutines in this service have no cancellation path?"
- "Where does `ctx` stop propagating? What's downstream of that boundary?"
- "Who owns this channel — who writes, who closes, who reads?"
- "What's the zero value of this type, and does it work?"
- "Is this a functional-options API that should just be a config struct?"
- "Which errors here are wrapped with `%w`, and which lose the chain?"
- "What happens to in-flight requests on SIGTERM?"
- "Is this `sync.Map` actually faster than `map + sync.RWMutex` for your access pattern, or cargo-culted?"
- "Where are you using `any` / `interface{}`, and could generics make it type-safe?"

## Package-boundary smells

- Types defined in one package but only used by another → probably in the wrong package.
- Circular import almost-avoided by introducing `types` / `models` / `common` → refactor to a proper boundary.
- `util` / `helpers` / `common` packages → rename by responsibility or split.
