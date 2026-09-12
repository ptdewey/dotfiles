# Heuristics library

Short catalog of named heuristics to reference by name in critique. Using the name is a forcing function — it signals the category of mistake to the reader.

## Design

- **Ousterhout — Deep modules.** Prefer small interfaces over large implementations. Classitis is an anti-pattern.
- **Ousterhout — Design it twice.** Produce two genuinely different designs before committing. *This skill enforces it.*
- **Parnas — Information hiding.** Each module hides a design decision likely to change. Boundaries follow change axes.
- **Gall's Law.** A complex system that works invariably evolved from a simple system that worked. Don't design the complex one up front.
- **Conway's Law.** Systems mirror the communication structure of the organizations that built them. If the system boundary doesn't match a team boundary, one of them is wrong.
- **Chesterton's Fence.** Don't remove what you don't understand. Before ripping anything out, find out why it's there.
- **Postel's Law (cautiously).** Be conservative in what you send, liberal in what you accept. Historically useful, sometimes a footgun for security and interop.

## Change and evolution

- **Hyrum's Law.** With sufficient users, every observable behavior of your system will be depended on. Your public surface is larger than you think.
- **Two-way vs one-way door (Bezos, 2015).** Escalate rigor for decisions you can't reverse cheaply. Go fast on the rest.
- **Strangler Fig (Fowler).** Migrate by routing new calls to the new system and letting the old one wither.
- **Branch by Abstraction.** Introduce an abstraction over the thing you want to replace, build the replacement behind it, switch, remove the abstraction.
- **Parallel Run.** Run old and new side-by-side, compare outputs, cut over when confident.

## Failure

- **Little's Law.** L = λW. Queues grow when arrival rate exceeds service rate. Backpressure is not optional.
- **Metastable failures.** Systems that recover to a degraded steady state after overload; look for positive feedback loops.
- **Cascading failure.** Retry storms are the most common cause. Jitter, budget, circuit-break.
- **Gray failure.** A component that's "up" from its own point of view but broken from a caller's. Design for observability from the caller's perspective.

## Social

- **The Mythical Man-Month (Brooks).** Adding people to a late project makes it later.
- **Second-system effect.** The rewrite is bigger, grander, and worse than the thing it replaces.
- **Chesterton's deployment fence.** Every deploy pipeline step exists because something broke once. Treat removals with suspicion.

## Usage in critique

When flagging a concern, reach for a name: *"This is a Hyrum's-Law risk"* is sharper than *"people might depend on this"*. Named heuristics travel further in a design review.
