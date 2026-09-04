# Architecture Language

Use these words consistently in architecture reviews and refactoring proposals. Go terms such as package, exported name, constructor, method set, and interface are welcome, but keep the architectural vocabulary stable.

## Terms

**Module**
Anything with an interface and an implementation. In Go this might be a package, type, function, command, or vertical slice.
_Avoid_: component, unit, service.

**Interface**
Everything a caller must know to use a module correctly: exported functions, methods, types, invariants, error semantics, ordering constraints, context/cancellation behavior, required configuration, and performance expectations. This is broader than a Go `interface` type.
_Avoid_: API, signature.

**Implementation**
The code hidden behind a module's interface: unexported helpers, data structures, adapters, goroutines, SQL, caches, and coordination logic.

**Depth**
Leverage at the interface. A module is **deep** when callers learn a small interface and receive a lot of behavior. A module is **shallow** when the interface is nearly as complex as the implementation.

**Seam**
A place where behavior can vary without editing the caller. In Go this is often a small consumer-owned interface, function parameter, package boundary, or command boundary.
_Avoid_: boundary, unless discussing DDD bounded contexts.

**Adapter**
A concrete thing that satisfies an interface at a seam: a Postgres store, HTTP client, in-memory fake, filesystem adapter, or clock.

**Leverage**
What callers get from depth: more capability per exported name, parameter, or invariant they must learn.

**Locality**
What maintainers get from depth: change, bugs, knowledge, and verification concentrate in one place.

## Principles

- **Depth is a property of the interface, not line count.** A deep Go package can have many unexported helpers behind a small exported surface.
- **The interface is the test surface.** Tests should usually cross the same seam as callers.
- **The deletion test:** if deleting a module makes complexity vanish, it was likely a pass-through; if complexity reappears across many callers, it was earning its keep.
- **One adapter is a hypothetical seam; two adapters make the seam real.** Do not introduce a Go interface just because a struct exists.
- **Accept interfaces, return concrete types** unless hiding the implementation is the point.
- **Define interfaces where they are consumed**, not beside the implementation by default.
- **Small interfaces are stronger.** Prefer `io.Reader`-style capabilities over broad object-shaped contracts.

## Go-specific smell tests

- Interface defined next to its only implementation.
- Package has many exported names but little behavior.
- Package name is `util`, `common`, `helper`, or `manager`.
- A `service` or `repository` package mostly forwards calls.
- Callers must know implementation details, SQL shape, retry behavior, or ordering rules.
- Tests need excessive mocks to exercise ordinary behavior.
- `any`, reflection, or generics substitute for a clearer domain type.
- Global mutable state makes tests order-dependent.
