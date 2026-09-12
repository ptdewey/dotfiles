# Deep Modules in Go

A **deep module** has a small interface and substantial behavior hidden behind it.

In Go, a module may be a package, type, function, command, or vertical slice. Depth usually shows up as a small exported surface with clear error semantics and unexported implementation details.

## Deep

```txt
Small exported surface
├── New(...)
├── Run(ctx, input)
└── Result type + documented errors

Hidden implementation
├── validation
├── persistence
├── retries
├── concurrency
├── parsing
└── adapters
```

Callers learn little and get a lot.

## Shallow

```txt
Wide exported surface
├── ValidateFoo
├── BuildFoo
├── SaveFoo
├── RetryFoo
├── ConvertFoo
└── SendFoo

Thin implementation
└── mostly forwards to other packages
```

Callers must orchestrate the behavior themselves.

## Go heuristics

- Prefer cohesive packages over thin layer packages.
- Keep exported names few and intentional.
- Use unexported helper types freely inside a package.
- Make zero values useful when natural; otherwise provide a constructor.
- Use small consumer-owned interfaces at real seams.
- Hide concurrency, retries, caching, and validation behind the module when callers should not coordinate them.
- Avoid package splits made only so tests can reach internals; test through the exported interface when possible.

## Questions to ask

- What does the caller have to know to use this correctly?
- Which invariants can move behind the interface?
- If this package disappeared, would complexity concentrate or scatter?
- Can tests exercise behavior through one exported seam?
- Are there actually two adapters, or did we invent an interface too early?
