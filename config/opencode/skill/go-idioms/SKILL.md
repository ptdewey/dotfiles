---
name: go-idioms
description: Expert guidance on idiomatic Go code, best practices, and common mistakes. Use when making design decisions in Go, evaluating if code is idiomatic, reviewing Go code quality, or when the user asks about Go best practices, conventions, or "the Go way" of doing things.
---

This skill guides writing idiomatic, production-quality Go code. Apply these principles when designing APIs, structuring code, handling errors, and making architectural decisions.

## Go Proverbs (Core Philosophy)

These proverbs from Rob Pike capture Go's design philosophy:

- **Don't communicate by sharing memory; share memory by communicating** - Use channels to coordinate, not shared state with locks
- **Concurrency is not parallelism** - Concurrency is structure; parallelism is execution
- **Channels orchestrate; mutexes serialize** - Choose based on the problem: coordination vs. protection
- **The bigger the interface, the weaker the abstraction** - Small interfaces are more powerful
- **Make the zero value useful** - Design types so uninitialized values work correctly
- **`interface{}` says nothing** - Empty interface provides no compile-time guarantees
- **Gofmt's style is no one's favorite, yet gofmt is everyone's favorite** - Consistency trumps personal preference
- **A little copying is better than a little dependency** - Don't import a package for one function
- **Syscall must always be guarded with build tags** - Platform-specific code needs constraints
- **Cgo must always be guarded with build tags** - Cgo has hidden costs
- **Cgo is not Go** - Crossing the boundary has significant overhead
- **With the unsafe package there are no guarantees** - Unsafe breaks Go's safety promises
- **Clear is better than clever** - Optimize for reading, not writing
- **Reflection is never clear** - Use reflection only when truly necessary
- **Errors are values** - Errors can be programmed, not just checked
- **Don't just check errors, handle them gracefully** - Add context, make decisions
- **Design the architecture, name the components, document the details** - Names matter
- **Documentation is for users** - Write docs for the reader, not the author

## Design Principles

### Simplicity Over Complexity

- Prefer straightforward solutions over clever ones
- If a design requires explanation, simplify it
- Avoid premature abstraction; wait for patterns to emerge
- Question every interface, every indirection, every layer

### Accept Interfaces, Return Structs

- Functions should accept the narrowest interface that works
- Return concrete types to give callers full access
- Exception: Return interface when hiding implementation details intentionally

### Make Zero Values Useful

Design types so the zero value is immediately usable:

- `sync.Mutex{}` is ready to use (unlocked)
- `bytes.Buffer{}` is ready to use (empty buffer)
- Slices: `nil` slice works with `append`, `len`, `range`

If zero value can't be useful, provide a constructor and document it.

### Error Handling Philosophy

- Errors are values to be programmed, not exceptions to be caught
- Handle errors at the level with enough context to make decisions
- Add context when propagating: `fmt.Errorf("operation failed: %w", err)`
- Sentinel errors for expected conditions; wrapped errors for unexpected
- Don't ignore errors; explicitly handle or document why ignored

### Package Design

- Package name should describe what it provides, not what it contains
- Avoid `util`, `common`, `helpers`, `misc` - these attract grab-bag code
- One package = one idea; if you can't name it simply, it's doing too much
- Internal packages for implementation details not meant for external use

## Code Organization

### Project Structure

```
project/
├── cmd/                    # Main applications
│   └── myapp/main.go
├── internal/               # Private packages (enforced by Go)
│   ├── service/
│   └── repository/
├── pkg/                    # Public packages (optional, explicit)
└── go.mod
```

### File Organization

- One file per major type or concept
- `doc.go` for package-level documentation
- `*_test.go` alongside implementation
- Group related functions together

### Naming Conventions

| Element    | Convention                     | Example                            |
| ---------- | ------------------------------ | ---------------------------------- |
| Packages   | Short, lowercase, singular     | `user`, `http`, `json`             |
| Interfaces | `-er` suffix for single-method | `Reader`, `Stringer`, `Handler`    |
| Getters    | No `Get` prefix                | `user.Name()` not `user.GetName()` |
| Acronyms   | All caps or all lower          | `URL`, `ID`, `xmlHTTPRequest`      |
| Unexported | Lowercase first letter         | `parseConfig`, `userCache`         |

### Interface Guidelines

- Define interfaces where they're used, not where implemented
- One method interfaces are powerful: `io.Reader`, `io.Writer`, `fmt.Stringer`
- Larger interfaces should be compositions of smaller ones
- Don't export interfaces "just in case" - export when there's a real need

## Reference Guides

Detailed patterns and anti-patterns:

- **[Common Mistakes](references/mistakes.md)**: Frequently encountered bugs and anti-patterns
- **[Idiomatic Patterns](references/patterns.md)**: Standard solutions for common problems
- **[Performance](references/performance.md)**: Optimization guidelines and pitfalls
- **[Tooling](references/tooling.md)**: Go tooling usage best practices

## Quick Smell Tests

Signs code may not be idiomatic:

| Smell                                 | Likely Issue                                         |
| ------------------------------------- | ---------------------------------------------------- |
| Many small interfaces in same package | Over-engineering; interfaces should emerge from need |
| Getter/setter pairs for all fields    | Java-style; expose fields or rethink design          |
| `interface{}` in public API           | Weak contract; find a better abstraction             |
| Package named `util` or `common`      | Lacks cohesion; split by actual purpose              |
| Deep package nesting                  | Over-organization; flatten where possible            |
| Lots of type assertions               | Interface may be too broad                           |
| `init()` functions with side effects  | Hidden dependencies; prefer explicit initialization  |
| Global mutable state                  | Testing nightmare; use dependency injection          |
| Panics for recoverable errors         | Use error returns; panic is for bugs                 |
| Commented-out code                    | Delete it; version control remembers                 |
