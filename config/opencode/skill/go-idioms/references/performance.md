# Go Performance Guide

## Table of Contents

- [Performance Philosophy](#performance-philosophy)
- [Memory Management](#memory-management)
- [String Handling](#string-handling)
- [Slices and Maps](#slices-and-maps)
- [Concurrency Performance](#concurrency-performance)
- [Interface Overhead](#interface-overhead)
- [Compiler Optimizations](#compiler-optimizations)
- [Profiling and Measurement](#profiling-and-measurement)

---

## Performance Philosophy

### Measure First

**Never optimize without profiling.** Intuition about performance is often wrong.

1. Write correct, clear code first
2. Benchmark to identify actual bottlenecks
3. Profile to understand root cause
4. Optimize the measured problem
5. Verify improvement with benchmarks

### Optimization Priorities

1. **Algorithm complexity** - O(n²) to O(n log n) beats any micro-optimization
2. **Memory allocation** - Reduce allocations in hot paths
3. **Data locality** - Keep related data together
4. **Concurrency** - Parallelize embarrassingly parallel work
5. **Micro-optimizations** - Last resort; often counterproductive

### When to Optimize

| Optimize | Don't Optimize |
|----------|----------------|
| Proven hot paths (profiled) | Speculation |
| User-facing latency | Internal tools |
| Resource-constrained environments | Plenty of headroom |
| Algorithmic improvements | Clever bit tricks |

---

## Memory Management

### Allocation Awareness

Each allocation has cost:
- Heap allocation overhead
- Garbage collector pressure
- Potential cache misses

**Hot path guideline**: Aim for zero allocations in tight loops.

### Stack vs Heap

**Stack allocated** (fast):
- Small objects
- Objects that don't escape function
- Known size at compile time

**Heap allocated** (slower):
- Returned from function (escape)
- Stored in interface
- Too large for stack
- Size unknown at compile time

Use `go build -gcflags="-m"` to see escape analysis decisions.

### Reducing Allocations

**Pre-allocate slices**: `make([]T, 0, expectedSize)` avoids growing.

**Reuse buffers**: `sync.Pool` for frequently allocated objects.

**Avoid unnecessary conversions**: `string([]byte)` and `[]byte(string)` both allocate.

**Pass pointers for large structs**: Avoid copying large values (>64 bytes as guideline).

**Use value receivers for small types**: Avoid pointer indirection overhead.

### sync.Pool Usage

For objects allocated and released frequently:

```
var bufferPool = sync.Pool{
    New: func() interface{} {
        return new(bytes.Buffer)
    },
}

// Get from pool
buf := bufferPool.Get().(*bytes.Buffer)
buf.Reset()

// Return to pool
bufferPool.Put(buf)
```

**Caution**: Pool objects may be collected between GC cycles; not for long-lived caching.

---

## String Handling

### String Building

| Method | Allocations | Use When |
|--------|-------------|----------|
| `+` | Per operation | 2-3 strings, not in loop |
| `fmt.Sprintf` | Multiple | Formatting needed |
| `strings.Builder` | Amortized | Loop, many concatenations |
| `strings.Join` | One | Array of strings |
| `[]byte` append | Amortized | Building with bytes |

### strings.Builder Efficiency

```
var b strings.Builder
b.Grow(estimatedSize) // Pre-allocate if size known
for _, s := range parts {
    b.WriteString(s)
}
result := b.String()
```

### Avoid Repeated Conversions

**Bad**: Converting between string and []byte in loop.

**Good**: Stay in one representation; convert once at boundary.

### String Interning

For many duplicate strings, consider interning (single copy per unique string). Standard library doesn't provide this; implement if profiling shows string memory dominance.

---

## Slices and Maps

### Slice Pre-allocation

**Known size**: `make([]T, 0, size)` then append.

**Unknown but bounded**: Allocate maximum, reslice result.

**Completely unknown**: Accept growth cost or use linked structure.

### Slice Growth Cost

Append doubles capacity when growing. For n items:
- Worst case: log(n) allocations
- Amortized O(1) per append

Pre-allocation eliminates all intermediate allocations.

### Map Pre-allocation

`make(map[K]V, size)` pre-allocates buckets:
- Reduces rehashing during population
- Significant for large maps built at once
- Less impact for maps grown incrementally

### Map vs Slice Lookup

| Size | Prefer |
|------|--------|
| <10 elements | Linear search on slice often faster |
| 10-100 | Either; benchmark for your case |
| >100 | Map wins clearly |

### Clearing Collections

**Reuse slice**: `slice = slice[:0]` keeps capacity.

**Reuse map**: Iterate and delete, or allocate new if complete replacement.

---

## Concurrency Performance

### Goroutine Overhead

- ~2KB stack (grows as needed)
- Scheduling overhead per context switch
- Channel operations have synchronization cost

**Not free, but cheap.** Don't spawn goroutine per tiny task.

### Channel vs Mutex Performance

| Pattern | Mutex | Channel |
|---------|-------|---------|
| Simple counter | Faster | Slower |
| Protect struct | Similar | Similar |
| Work distribution | N/A | Designed for this |
| Complex coordination | Error-prone | Cleaner |

**Guideline**: Mutex for data protection, channels for coordination.

### Bounded Concurrency

Limit goroutines to avoid:
- Memory exhaustion
- Connection pool exhaustion  
- Rate limiting issues

Use semaphore pattern (buffered channel) or worker pool.

### False Sharing

When goroutines modify adjacent memory locations, CPU cache lines invalidate:

**Problem**: Struct fields modified by different goroutines.

**Solution**: Pad with unused fields, or restructure to separate data.

### Lock Contention

High contention symptoms:
- CPU utilization low despite work available
- Profiler shows time in mutex operations

Solutions:
- Reduce critical section duration
- Shard data to multiple locks
- Use atomic operations for simple counters
- Consider lock-free structures

---

## Interface Overhead

### Interface Costs

**Indirection**: Method calls through interface require vtable lookup.

**Allocation**: Storing value in interface may allocate (escape to heap).

**Inlining prevention**: Compiler can't inline interface method calls.

### When Interface Overhead Matters

- Tight inner loops (millions of calls)
- Known single implementation in hot path

### Mitigation

**Type assertion in hot path**: If type known at runtime, assert and call directly.

**Generic instead of interface**: Go 1.18+ generics enable monomorphization in some cases.

**Accept concrete in internal code**: Export interface; internal functions take concrete.

---

## Compiler Optimizations

### Inlining

Compiler inlines small functions automatically. Helps:
- Eliminates call overhead
- Enables further optimizations
- Works best with small, simple functions

Check with `go build -gcflags="-m"`.

### Bounds Check Elimination

Compiler eliminates bounds checks when provable safe:

```
for i := 0; i < len(s); i++ {
    _ = s[i] // Bounds check eliminated
}
```

Help compiler by using obvious patterns; avoid clever indexing.

### Dead Code Elimination

Unreachable code removed. Use build tags or const booleans for conditional compilation that disappears in production.

---

## Profiling and Measurement

### Benchmarking

```
func BenchmarkFunction(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Function()
    }
}
```

Run: `go test -bench=. -benchmem`

Report includes: ns/op, B/op (bytes allocated), allocs/op.

### CPU Profiling

```
import _ "net/http/pprof"
go func() { http.ListenAndServe(":6060", nil) }()
```

Collect: `go tool pprof http://localhost:6060/debug/pprof/profile?seconds=30`

Analyze: `top`, `list FunctionName`, `web` (generates graph).

### Memory Profiling

Collect: `go tool pprof http://localhost:6060/debug/pprof/heap`

Types:
- `inuse_space`: Currently allocated
- `alloc_space`: Total allocated (includes freed)
- `inuse_objects`: Object count
- `alloc_objects`: Total objects allocated

### Trace

Full execution trace: `go tool trace trace.out`

Shows:
- Goroutine execution timeline
- GC events
- System call blocking
- Network I/O

Useful for understanding concurrency behavior.

### Benchmark Comparison

```
go test -bench=. -count=10 > old.txt
# make changes
go test -bench=. -count=10 > new.txt
benchstat old.txt new.txt
```

Statistical comparison of benchmark results.

---

## Common Performance Pitfalls

| Pitfall | Impact | Solution |
|---------|--------|----------|
| Allocation in hot loop | GC pressure, latency | Pre-allocate, reuse, sync.Pool |
| String concatenation in loop | Quadratic allocation | strings.Builder |
| Unbounded goroutines | Memory exhaustion | Worker pool, bounded channels |
| Large value copies | CPU, memory | Use pointers for large structs |
| Unnecessary interface | Indirection, allocation | Concrete types in hot paths |
| Map iteration for small set | Overhead | Use slice for <10 elements |
| Reflection in hot path | 10-100x slower | Generate code, use type assertions |
| Excessive logging | I/O, allocation | Level guards, sampling |
