# Interface Design for Go

Design interfaces so ordinary callers and tests cross the same seam.

## Principles

- Accept interfaces, return concrete types.
- Define interfaces where they are consumed.
- Keep interfaces small and capability-shaped.
- Prefer concrete types until variation is real.
- Make zero values useful when natural.
- Return errors with enough context for the caller to decide.
- Pass `context.Context` explicitly for cancellation, deadlines, and request scope.
- Avoid hidden goroutines or background work unless the lifecycle is explicit.

## Good seam

```go
type UserStore interface {
	CreateUser(context.Context, CreateUserInput) (User, error)
	User(context.Context, UserID) (User, error)
}

func RegisterUser(ctx context.Context, store UserStore, input RegisterUserInput) (User, error) {
	// behavior hidden here
}
```

The caller knows the behavior it needs, not the implementation details.

## Weak seam

```go
type UserRepository interface {
	Begin() error
	Validate(input CreateUserInput) error
	Insert(input CreateUserInput) (int64, error)
	Commit() error
	Rollback() error
}
```

The caller must orchestrate the implementation. The interface is shallow.

## Checklist

- Can this be a concrete type instead of an interface?
- If it is an interface, does the consumer own it?
- Can the method count shrink?
- Are error semantics documented or obvious?
- Does the interface expose ordering constraints that should be internal?
- Can callers use the zero value safely?
- Is `context.Context` passed as the first parameter where appropriate?
