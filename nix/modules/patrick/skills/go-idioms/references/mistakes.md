# Common Go Mistakes

## Table of Contents

- [Error Handling](#error-handling)
- [Concurrency](#concurrency)
- [Slices and Maps](#slices-and-maps)
- [Strings and Bytes](#strings-and-bytes)
- [Interfaces and Types](#interfaces-and-types)
- [Control Flow](#control-flow)
- [Resource Management](#resource-management)
- [Testing](#testing)

---

## Error Handling

### Ignoring Errors

**Mistake**: Discarding errors with `_` or not checking at all.

**Why it matters**: Silent failures cause debugging nightmares. The error exists because something can go wrong.

**Fix**: Handle every error. If truly ignorable, document why:
```
_ = file.Close() // Error ignored: best-effort cleanup, already handled primary error
```

### Not Adding Context

**Mistake**: Returning errors without additional context.

**Why it matters**: `"connection refused"` tells you nothing about what operation failed.

**Fix**: Wrap with context using `fmt.Errorf("connecting to %s: %w", addr, err)`.

### Checking Error Type After Wrapping

**Mistake**: Using `==` to compare wrapped errors.

**Why it matters**: `err == io.EOF` fails when error is wrapped.

**Fix**: Use `errors.Is(err, io.EOF)` for value comparison, `errors.As(err, &target)` for type extraction.

### Overusing Sentinel Errors

**Mistake**: Creating exported error variables for every error case.

**Why it matters**: Sentinel errors become part of your API; changing them breaks callers.

**Fix**: Use sentinel errors only for conditions callers must distinguish programmatically. Otherwise, return descriptive error strings.

### Double-Wrapping Errors

**Mistake**: `fmt.Errorf("failed: %w", fmt.Errorf("operation: %w", err))` creating redundant chains.

**Why it matters**: Creates confusing error messages and unnecessary nesting.

**Fix**: Wrap once at each meaningful boundary with new context.

---

## Concurrency

### Race Conditions on Loop Variables

**Mistake**: Capturing loop variable in goroutine without copying.

**Why it matters**: All goroutines see the final value of the loop variable.

**Fix**: Pass as parameter `go func(v Value) { ... }(item)` or declare local copy `v := item`.

### Forgetting WaitGroup Add Before Go

**Mistake**: Calling `wg.Add(1)` inside the goroutine instead of before.

**Why it matters**: Race condition - `wg.Wait()` may return before `Add` is called.

**Fix**: Always call `wg.Add()` before spawning the goroutine, in the launching goroutine.

### Channel Not Closed by Sender

**Mistake**: Receiver trying to close channel, or no one closing at all.

**Why it matters**: Only sender knows when sending is done. Receivers ranging over unclosed channels block forever.

**Fix**: Sender closes; receivers range or use select with done channel.

### Mutex Copied After First Use

**Mistake**: Passing `sync.Mutex` by value instead of pointer.

**Why it matters**: Copying a mutex copies its locked state; both copies think they own the lock.

**Fix**: Always pass `*sync.Mutex` or embed in struct passed by pointer.

### Goroutine Leak

**Mistake**: Spawning goroutines without ensuring they terminate.

**Why it matters**: Leaked goroutines consume memory forever.

**Fix**: Ensure every goroutine has an exit condition - context cancellation, done channel, or finite work.

### Data Race on Maps

**Mistake**: Concurrent read/write to map without synchronization.

**Why it matters**: Maps are not thread-safe; concurrent access causes crashes.

**Fix**: Use `sync.Mutex`, `sync.RWMutex`, or `sync.Map` for concurrent access.

### Blocking Forever on Unbuffered Channel

**Mistake**: Sending to unbuffered channel with no receiver ready.

**Why it matters**: Goroutine blocks forever, often causing deadlock.

**Fix**: Ensure receiver exists, use buffered channel if appropriate, or use select with default/timeout.

---

## Slices and Maps

### Nil Map Write

**Mistake**: Writing to a nil map.

**Why it matters**: Nil map reads return zero value; writes panic.

**Fix**: Initialize with `make(map[K]V)` or literal before writing.

### Slice Capacity Confusion

**Mistake**: Assuming `append` always returns new backing array.

**Why it matters**: Slices share backing arrays until capacity exceeded; modifications affect original.

**Fix**: Use `copy` for independent slice, or `append(slice[:0:0], slice...)` to force new array.

### Modifying Slice During Iteration

**Mistake**: Appending to or deleting from slice while ranging over it.

**Why it matters**: Range uses copy of slice header; modifications may skip or duplicate elements.

**Fix**: Iterate over indices with careful index management, or build new slice.

### Empty Slice vs Nil Slice

**Mistake**: Treating nil slice and empty slice as identical in JSON serialization.

**Why it matters**: `nil` marshals to `null`; `[]T{}` marshals to `[]`.

**Fix**: Initialize explicitly if you need specific JSON output; use `make([]T, 0)` for empty array.

### Map Iteration Order

**Mistake**: Depending on map iteration order.

**Why it matters**: Go randomizes map iteration intentionally; order is never guaranteed.

**Fix**: Sort keys separately if order matters.

---

## Strings and Bytes

### String Concatenation in Loop

**Mistake**: Using `+=` for string building in loops.

**Why it matters**: Strings are immutable; each `+=` allocates new string.

**Fix**: Use `strings.Builder` for multiple concatenations.

### Iterating Strings by Index

**Mistake**: `s[i]` when expecting Unicode characters.

**Why it matters**: String indexing returns bytes, not runes; multi-byte characters break.

**Fix**: Range over string for runes: `for i, r := range s`.

### Incorrect String Length

**Mistake**: Using `len(s)` for character count.

**Why it matters**: `len` returns bytes; UTF-8 characters may be multiple bytes.

**Fix**: Use `utf8.RuneCountInString(s)` for character count.

### Unnecessary String/Byte Conversion

**Mistake**: Converting `[]byte` to `string` and back repeatedly.

**Why it matters**: Each conversion allocates; strings are immutable copies.

**Fix**: Stay in one representation as long as possible; many functions accept both.

---

## Interfaces and Types

### Interface Pollution

**Mistake**: Defining interfaces before they're needed.

**Why it matters**: Interfaces should emerge from use, not speculation. Premature interfaces complicate design.

**Fix**: Write concrete code first; extract interfaces when you have multiple implementations or need testing boundaries.

### Returning Concrete Types as Interfaces

**Mistake**: Function signature returns interface when it always returns same concrete type.

**Why it matters**: Caller loses access to type-specific methods; loses information unnecessarily.

**Fix**: Return concrete type; accept interfaces, return structs.

### Nil Interface vs Nil Value in Interface

**Mistake**: Checking `if err != nil` when error contains nil pointer.

**Why it matters**: Interface containing nil concrete value is not itself nil.

**Fix**: Don't return typed nil errors; return nil directly: `return nil` not `return (*MyError)(nil)`.

### Type Assertion Without Check

**Mistake**: `x.(T)` without comma-ok form.

**Why it matters**: Panics if assertion fails.

**Fix**: Use `v, ok := x.(T)` and handle the false case.

### Pointer vs Value Receivers Mixing

**Mistake**: Type has both pointer and value receivers inconsistently.

**Why it matters**: Confuses whether type should be used by value or pointer; method sets differ.

**Fix**: Pick one receiver type and stick with it; pointer if type has mutable state or is large.

---

## Control Flow

### Forgetting Break in Type Switch

**Mistake**: Expecting fallthrough in type switch.

**Why it matters**: Unlike expression switches, type switches don't support fallthrough; attempting it is compile error.

**Fix**: Combine cases: `case int, int64:`.

### Defer in Loop

**Mistake**: Deferring inside loop body.

**Why it matters**: Defers accumulate until function returns; resource buildup in long loops.

**Fix**: Extract loop body to function, or manage resources explicitly within loop.

### Defer Argument Evaluation

**Mistake**: Expecting defer arguments evaluated at defer execution time.

**Why it matters**: Arguments evaluated immediately when defer statement runs.

**Fix**: Use closure to capture current values, or be aware of evaluation timing.

### Named Return Shadow

**Mistake**: Declaring variable that shadows named return.

**Why it matters**: Naked return returns the named return value, which wasn't assigned.

**Fix**: Avoid shadowing; use explicit return with value.

---

## Resource Management

### HTTP Response Body Not Closed

**Mistake**: Not closing `resp.Body` after HTTP request.

**Why it matters**: Leaks connections; eventually exhausts connection pool.

**Fix**: Always `defer resp.Body.Close()` after checking error.

### File Not Closed

**Mistake**: Opening file without ensuring close.

**Why it matters**: File descriptor leak; eventually "too many open files".

**Fix**: `defer f.Close()` immediately after successful open.

### Database Rows Not Closed

**Mistake**: Not closing `sql.Rows` after iteration.

**Why it matters**: Holds database connection; pool exhaustion.

**Fix**: `defer rows.Close()` after query, or ensure `rows.Err()` called which closes.

### Context Leak

**Mistake**: Creating context with cancel but not calling cancel.

**Why it matters**: Resources associated with context not released.

**Fix**: Always `defer cancel()` after `context.WithCancel/Timeout/Deadline`.

---

## Testing

### Using Global State

**Mistake**: Tests depending on or modifying global state.

**Why it matters**: Tests interfere with each other; order-dependent failures.

**Fix**: Pass dependencies explicitly; use test fixtures; reset state in cleanup.

### Not Testing Error Paths

**Mistake**: Only testing happy path.

**Why it matters**: Error handling bugs are common and serious.

**Fix**: Test each error condition; verify error messages contain useful information.

### Testing Implementation Details

**Mistake**: Tests coupled to internal implementation.

**Why it matters**: Refactoring breaks tests even when behavior unchanged.

**Fix**: Test public API behavior, not internal structure.

### Missing Table-Driven Tests

**Mistake**: Copy-pasting similar tests with different inputs.

**Why it matters**: Hard to add cases; easy to make inconsistent changes.

**Fix**: Use table-driven tests with named cases.

### Test File in Wrong Package

**Mistake**: External tests (`package foo_test`) when internal access needed, or vice versa.

**Why it matters**: External tests can't access unexported symbols; internal tests don't verify public API.

**Fix**: Use `package foo` for white-box tests needing internals; `package foo_test` for black-box API tests.
