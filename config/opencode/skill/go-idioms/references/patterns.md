# Idiomatic Go Patterns

## Table of Contents

- [Error Handling Patterns](#error-handling-patterns)
- [Concurrency Patterns](#concurrency-patterns)
- [API Design Patterns](#api-design-patterns)
- [Functional Options Pattern](#functional-options-pattern)
- [Resource Management](#resource-management)
- [Testing Patterns](#testing-patterns)
- [Package Organization](#package-organization)

---

## Error Handling Patterns

### Wrap with Context

Add context at each meaningful level:

```
return fmt.Errorf("updating user %d: %w", userID, err)
```

Creates chain: `updating user 42: database: connection refused`

### Custom Error Types

When callers need to inspect error details:

```
type NotFoundError struct {
    Resource string
    ID       string
}

func (e *NotFoundError) Error() string {
    return fmt.Sprintf("%s %s not found", e.Resource, e.ID)
}
```

Check with `errors.As(err, &notFound)`.

### Error Sentinel Values

For errors callers need to check programmatically:

```
var ErrNotFound = errors.New("not found")
```

Check with `errors.Is(err, ErrNotFound)`. Use sparingly; becomes API contract.

### Errors as Control Flow

Errors are values; use them for decisions:

```
for {
    item, err := iter.Next()
    if errors.Is(err, io.EOF) {
        break // Expected: iteration complete
    }
    if err != nil {
        return err // Unexpected: actual error
    }
    process(item)
}
```

---

## Concurrency Patterns

### Worker Pool

Bounded parallelism with fixed worker count:

- Create buffered job channel
- Spawn N workers consuming from channel
- Send jobs to channel
- Close channel when done; workers exit naturally
- WaitGroup to know when workers finish

### Fan-Out/Fan-In

Distribute work, collect results:

- Fan-out: Multiple goroutines reading from one channel
- Fan-in: Multiple producers, one consumer merging results
- Use separate done channel or context for cancellation

### Pipeline

Chain stages connected by channels:

- Each stage: receives from input channel, sends to output channel
- Each stage runs in own goroutine
- Close output channel when input exhausted
- Error handling: separate error channel or context cancellation

### Context Cancellation

Propagate cancellation through call chain:

- Accept `context.Context` as first parameter
- Check `ctx.Done()` in loops and before blocking operations
- Pass context to all downstream calls
- Return `ctx.Err()` when cancelled

### Mutex vs Channel Decision

| Use Mutex | Use Channel |
|-----------|-------------|
| Protecting shared state | Coordinating goroutines |
| Simple increment/read | Passing ownership of data |
| Performance critical | Complex synchronization |
| State doesn't transfer | Producer/consumer patterns |

### Graceful Shutdown

Clean termination of concurrent system:

1. Trap shutdown signal (SIGTERM, SIGINT)
2. Create/cancel context
3. Stop accepting new work
4. Wait for in-flight work with timeout
5. Release resources

---

## API Design Patterns

### Accept Interfaces, Return Structs

Functions take minimal interface, return concrete type:

- Input: `io.Reader` not `*os.File`
- Output: `*bytes.Buffer` not `io.Writer`
- Caller gets full type; implementation uses narrow contract

### Constructor Functions

When zero value isn't useful:

```
func NewClient(addr string) *Client {
    return &Client{
        addr:    addr,
        timeout: 30 * time.Second,
        client:  &http.Client{},
    }
}
```

Name: `New<Type>` or `New` if package name is type.

### Method Chaining (Builder)

For complex object construction:

```
query := NewQuery().
    Select("name", "email").
    From("users").
    Where("active = ?", true).
    Limit(10)
```

Each method returns receiver. Call `Build()` or similar to get result.

### Interface Segregation

Define small, focused interfaces:

```
type Reader interface { Read(p []byte) (n int, err error) }
type Writer interface { Write(p []byte) (n int, err error) }
type ReadWriter interface { Reader; Writer }
```

Callers request only what they need.

---

## Functional Options Pattern

Flexible configuration without breaking changes:

### The Pattern

```
type Option func(*Server)

func WithTimeout(d time.Duration) Option {
    return func(s *Server) { s.timeout = d }
}

func WithLogger(l Logger) Option {
    return func(s *Server) { s.logger = l }
}

func NewServer(addr string, opts ...Option) *Server {
    s := &Server{
        addr:    addr,
        timeout: 30 * time.Second, // default
        logger:  defaultLogger,    // default
    }
    for _, opt := range opts {
        opt(s)
    }
    return s
}
```

### Usage

```
srv := NewServer("localhost:8080",
    WithTimeout(60*time.Second),
    WithLogger(customLogger),
)
```

### When to Use

- Many optional parameters
- Defaults should be common case
- Configuration may grow over time
- Clean call sites matter

### Alternatives

| Pattern | When to Use |
|---------|-------------|
| Functional options | Many optional params, extensibility needed |
| Config struct | Few params, explicit configuration preferred |
| Builder pattern | Complex construction with validation |
| Required params only | Simple cases, few variations |

---

## Resource Management

### Cleanup with Defer

Pair acquisition with deferred release:

```
f, err := os.Open(name)
if err != nil {
    return err
}
defer f.Close()
```

### Multiple Resources

Handle each resource independently:

```
src, err := os.Open(srcPath)
if err != nil {
    return err
}
defer src.Close()

dst, err := os.Create(dstPath)
if err != nil {
    return err
}
defer dst.Close()
```

### Cleanup Functions

Return cleanup function for caller to manage:

```
func SetupDatabase() (*DB, func(), error) {
    db := connect()
    cleanup := func() { db.Close() }
    return db, cleanup, nil
}

// Usage:
db, cleanup, err := SetupDatabase()
if err != nil {
    return err
}
defer cleanup()
```

### Context-Based Lifecycle

Tie resource lifecycle to context:

```
func StartWorker(ctx context.Context) {
    go func() {
        for {
            select {
            case <-ctx.Done():
                cleanup()
                return
            case job := <-jobs:
                process(job)
            }
        }
    }()
}
```

---

## Testing Patterns

### Table-Driven Tests

Test multiple cases with shared logic:

```
tests := []struct {
    name    string
    input   Input
    want    Output
    wantErr bool
}{
    {"empty input", Input{}, Output{}, false},
    {"valid case", Input{X: 1}, Output{Y: 2}, false},
    {"error case", Input{X: -1}, Output{}, true},
}

for _, tt := range tests {
    t.Run(tt.name, func(t *testing.T) {
        got, err := Function(tt.input)
        if (err != nil) != tt.wantErr {
            t.Errorf("error = %v, wantErr %v", err, tt.wantErr)
            return
        }
        if got != tt.want {
            t.Errorf("got %v, want %v", got, tt.want)
        }
    })
}
```

### Test Fixtures

Reusable test setup:

```
func setupTest(t *testing.T) (*Client, func()) {
    t.Helper()
    client := NewClient()
    return client, func() { client.Close() }
}

func TestFeature(t *testing.T) {
    client, cleanup := setupTest(t)
    defer cleanup()
    // test using client
}
```

### Interface for Testing

Define interface at point of use for test doubles:

```
// In production code
type store interface {
    Get(key string) (string, error)
}

type Service struct {
    store store
}

// In test
type mockStore struct {
    data map[string]string
}

func (m *mockStore) Get(key string) (string, error) {
    return m.data[key], nil
}
```

### Test Helpers

Mark helpers with `t.Helper()`:

```
func assertEqual(t *testing.T, got, want interface{}) {
    t.Helper()
    if got != want {
        t.Errorf("got %v, want %v", got, want)
    }
}
```

Errors report caller's line, not helper's.

---

## Package Organization

### Package by Feature

Group by domain concept, not technical layer:

**Prefer:**
```
order/
├── order.go      # Order type and business logic
├── repository.go # Data access
├── service.go    # Application service
└── handler.go    # HTTP handlers
```

**Avoid:**
```
models/order.go
repositories/order.go
services/order.go
handlers/order.go
```

### Internal Packages

Hide implementation details:

```
mylib/
├── mylib.go      # Public API
└── internal/
    └── impl/     # Internal implementation
```

`internal` enforced by Go toolchain; outside packages can't import.

### Package Naming

| Do | Don't |
|----|-------|
| `user` | `users` (singular) |
| `http` | `httputil` (unless stdlib) |
| `json` | `jsonhelper` |
| Short, clear | Stuttering: `user.User` |

### Dependency Direction

- Higher-level packages depend on lower-level
- Domain packages shouldn't depend on infrastructure
- Use interfaces to invert dependencies when needed

### Avoid Circular Imports

If packages need to import each other:
- Extract shared types to new package
- Use interfaces to break dependency
- Reconsider package boundaries
