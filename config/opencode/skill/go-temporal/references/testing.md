# Testing Patterns

## Table of Contents

- [Testing Philosophy](#testing-philosophy)
- [Test Environment](#test-environment)
- [Unit Testing Workflows](#unit-testing-workflows)
- [Unit Testing Activities](#unit-testing-activities)
- [Mocking Strategies](#mocking-strategies)
- [Testing Signals, Queries, and Updates](#testing-signals-queries-and-updates)
- [Testing Child Workflows](#testing-child-workflows)
- [Integration Testing](#integration-testing)
- [Time Manipulation](#time-manipulation)

---

## Testing Philosophy

### Testing Pyramid for Temporal

| Level | What to Test | Tools |
|-------|--------------|-------|
| Unit | Individual workflows with mocked activities | `TestWorkflowEnvironment` |
| Unit | Individual activities with mocked dependencies | `TestActivityEnvironment` or standard Go tests |
| Integration | Workflow + activities together | Test server or local Temporal |
| E2E | Full system with real services | Real Temporal + real dependencies |

### Key Principles

- **Test Workflows in Isolation**: Mock activities to focus on orchestration logic
- **Test Activities Independently**: Use dependency injection for external services
- **Time is Free**: Test environment auto-skips timers; test long-duration workflows quickly
- **Determinism Matters**: Tests catch non-deterministic workflow code

---

## Test Environment

### Test Suite Pattern

Use `testsuite.WorkflowTestSuite` for workflow tests:
- Embed in your test suite struct
- Create `TestWorkflowEnvironment` in `SetupTest`
- Call `AssertExpectations` in `TearDownTest`

### Key Components

| Component | Purpose |
|-----------|---------|
| `TestWorkflowEnvironment` | Simulates workflow execution with mocked activities |
| `TestActivityEnvironment` | Runs activities with simulated context |
| `TestServer` | In-memory Temporal server for integration tests |

### Dependencies

- `go.temporal.io/sdk/testsuite`
- `github.com/stretchr/testify/suite`
- `github.com/stretchr/testify/mock`
- `github.com/stretchr/testify/require`

---

## Unit Testing Workflows

### What to Test

- **Happy Path**: All activities succeed, correct result returned
- **Failure Handling**: Activity failures trigger expected behavior (retry, compensation, error)
- **Branching Logic**: Different inputs lead to different activity sequences
- **Signal Handling**: Signals modify workflow behavior correctly
- **Query Responses**: Queries return expected state at various points

### Test Structure

1. Create test environment
2. Mock activities with expected inputs/outputs
3. Execute workflow
4. Assert workflow completed
5. Assert no error (or expected error)
6. Assert result matches expectation

### Assertions

- `env.IsWorkflowCompleted()`: Workflow finished (success or failure)
- `env.GetWorkflowError()`: Error returned by workflow (nil for success)
- `env.GetWorkflowResult(&result)`: Deserialize workflow return value
- `env.AssertExpectations(t)`: Verify all mocked activities were called

### Testing Errors

- Mock activity to return `temporal.NewApplicationError()`
- Assert `env.GetWorkflowError()` returns error
- Use `errors.As()` to check error type
- Verify error type and details match expectations

---

## Unit Testing Activities

### Testing Approaches

**Standard Go Tests**: For activities that are pure functions or use dependency injection.

**TestActivityEnvironment**: When you need:
- Activity context (`activity.GetInfo`, `activity.GetLogger`)
- Heartbeat testing
- Worker options simulation

### What to Test

- **Success Cases**: Valid input produces expected output
- **Error Cases**: Invalid input or failures return appropriate errors
- **Idempotency**: Same input produces same result on repeated calls
- **Heartbeat Logic**: Progress saved and resumed correctly
- **Context Usage**: Cancellation respected, info accessed correctly

### Dependency Injection

Structure activities for testability:
- Put external clients in struct fields
- Create activities struct with mocked dependencies
- Test methods directly or via `TestActivityEnvironment`

---

## Mocking Strategies

### Activity Mocking

| Pattern | Use When |
|---------|----------|
| Exact arguments | Testing specific input handling |
| `mock.Anything` | Input doesn't matter for this test |
| `mock.MatchedBy(func)` | Custom validation of arguments |
| Function return | Dynamic responses based on input or call count |

### Dynamic Mocking

Return a function to:
- Simulate retries (fail first, succeed later)
- Track call counts
- Return different results based on input
- Simulate timing effects

### Struct Method Mocking

Mock methods on activity structs:
- Declare nil pointer of activity struct type
- Use method reference in `OnActivity`
- Type-safe and refactor-friendly

---

## Testing Signals, Queries, and Updates

### Signal Testing

Use `RegisterDelayedCallback` to send signals at specific times:
- Callback fires at simulated time offset
- Use `env.SignalWorkflow(signalName, payload)` inside callback
- Test workflow response to signals at different execution points

### Query Testing

Query workflow state during execution:
- Register callback at desired point
- Call `env.QueryWorkflow(queryName, args...)`
- Assert query result matches expected state
- Queries don't affect workflow execution

### Update Testing

Test update handlers with validation:
- Use `env.UpdateWorkflow(updateName, updateID, args...)`
- Verify validation errors rejected
- Verify successful updates modify state
- Test concurrent updates if relevant

---

## Testing Child Workflows

### Mocking Child Workflows

- `env.OnWorkflow(ChildWorkflow, args...).Return(result, err)`
- Child workflow doesn't execute; returns mocked value
- Test parent's handling of child results/errors

### Testing Real Child Execution

- Don't mock the child workflow
- Mock child's activities instead
- Tests parent-child interaction and composition
- Useful for integration-level workflow tests

### Testing Cancellation

- Mock parent cancellation via signal or timeout
- Verify child receives cancellation based on `ParentClosePolicy`
- Test cleanup and compensation logic

---

## Integration Testing

### Test Server

`testsuite.NewTestServer()` provides:
- In-memory Temporal server
- No external dependencies
- Fast startup/shutdown
- Full Temporal functionality

### Integration Test Structure

1. Start test server
2. Create client from server
3. Create and start worker with real workflows/activities
4. Execute workflow via client
5. Wait for result
6. Assert expectations
7. Stop worker and server

### When to Use

- Testing workflow + activity interaction
- Testing retries and timeouts with real behavior
- Validating signal/query from client perspective
- Testing worker registration and routing

### Real Server Testing

For tests against actual Temporal server:
- Skip if `TEMPORAL_ADDRESS` not set
- Use unique task queues per test
- Clean up workflows after tests
- Consider namespace isolation

---

## Time Manipulation

### Automatic Time Skipping

Test environment auto-skips timers:
- `workflow.Sleep(ctx, 24*time.Hour)` completes instantly
- Long timeouts don't slow tests
- Test hours/days of workflow time in milliseconds

### Controlling Time

- `env.SetTestTimeout(duration)`: Maximum test duration
- `OnActivity().After(duration)`: Simulate activity taking time
- `RegisterDelayedCallback(func, offset)`: Execute at simulated time

### Testing Timers

- **Timeout Reached**: Don't send signal; timer fires automatically
- **Signal Before Timeout**: Send signal in callback before timer duration
- **Deadline Exceeded**: Configure activity/workflow timeout; verify error type

### Guidelines

- Test both timer-fires and signal-wins scenarios
- Verify correct branch executes for each case
- Test edge cases (signal at exactly timeout time)
- Use `temporal.IsTimeoutError(err)` for timeout assertions

---

## Test Fixtures and Helpers

### Fixture Guidelines

- Create factory functions for test data (`NewTestOrder()`)
- Use random IDs to avoid test pollution
- Keep fixtures minimal; add only needed fields
- Document fixture assumptions

### Custom Assertions

Build helpers for common assertions:
- Activity call verification
- Error type checking
- Workflow panic detection
- State machine transitions

### Guidelines

- Keep tests focused on one behavior
- Use descriptive test names
- Clean up resources in teardown
- Avoid test interdependence
