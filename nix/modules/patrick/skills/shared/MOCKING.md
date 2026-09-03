# Mocking in Go

Prefer fakes and real test adapters over mocks. Mock only at seams where behavior genuinely varies or where the dependency is outside your control.

## Mock at system boundaries

Good boundaries to replace in tests:

- Remote HTTP/gRPC APIs.
- Time and randomness.
- Filesystem and process execution.
- Message brokers and external queues.
- Databases when a real test database is impractical.

## Prefer these tools

- `httptest.Server` for HTTP clients.
- `httptest.ResponseRecorder` for HTTP handlers.
- In-memory adapters for stores when persistence details are not the behavior under test.
- `t.TempDir()` and `fstest.MapFS` for filesystem behavior.
- Small interfaces like `Clock`, `Sender`, `Store`, `Reader`, or `Writer`.

## Avoid

- Generated mocks for every interface by default.
- Mocking your own internal packages just to verify call counts.
- Interfaces with many methods created only for mocking.
- Assertions on call order unless order is part of the contract.
- `any`-heavy mock hooks that erase the shape of the behavior.

## Dependency shape

Accept narrow interfaces where the dependency is consumed:

```go
type EmailSender interface {
	SendWelcomeEmail(ctx context.Context, user User) error
}

func RegisterUser(ctx context.Context, users UserStore, email EmailSender, input RegisterInput) (User, error) {
	// ...
}
```

Do not export a broad interface beside an implementation just because tests might need one later.
