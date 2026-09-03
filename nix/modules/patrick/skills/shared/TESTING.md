# Go Testing Guidance

Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests should survive when behavior stays the same.

## Good tests

Good Go tests exercise observable behavior through exported functions, methods, handlers, CLIs, or package-level seams.

```go
func TestCreateUserMakesUserRetrievable(t *testing.T) {
	ctx := context.Background()
	store := newTestStore(t)

	created, err := store.CreateUser(ctx, CreateUserInput{Name: "Alice"})
	if err != nil {
		t.Fatal(err)
	}

	got, err := store.User(ctx, created.ID)
	if err != nil {
		t.Fatal(err)
	}

	if got.Name != "Alice" {
		t.Fatalf("got name %q, want %q", got.Name, "Alice")
	}
}
```

Characteristics:

- Uses the same seam as callers.
- Names the behavior being specified.
- Avoids assertions about internal call order unless order is observable behavior.
- Keeps setup boring and explicit.
- Fails for meaningful behavior changes.

## Table tests

Use table tests when the behavior is the same shape across inputs.

```go
func TestParseAmount(t *testing.T) {
	tests := []struct {
		name string
		in   string
		want int64
	}{
		{name: "dollars", in: "12.00", want: 1200},
		{name: "cents", in: "0.99", want: 99},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := ParseAmount(tt.in)
			if err != nil {
				t.Fatal(err)
			}
			if got != tt.want {
				t.Fatalf("got %d, want %d", got, tt.want)
			}
		})
	}
}
```

## Useful standard-library tools

- `testing` for ordinary tests and benchmarks.
- `httptest` for HTTP handlers and clients.
- `fstest` and `t.TempDir()` for filesystem behavior.
- `iotest` for readers/writers and error cases.
- `context` deadlines/cancellation for cancellation behavior.
- `go test -race` when goroutines or shared state are involved.
- fuzz tests for parsers, validators, codecs, and protocol handling.

## Bad tests

Avoid tests that couple to implementation details:

- Asserting that an internal helper was called.
- Mocking owned collaborators instead of testing through the module interface.
- Testing unexported helpers because the exported interface is awkward.
- Querying a database directly when the behavior should be verified through the store interface.
- Making tests pass by matching current structure rather than intended behavior.

Testing unexported helpers is acceptable when the helper contains genuinely complex behavior and the package-level interface would make failures too opaque. Treat that as a design smell to evaluate, not a default.
