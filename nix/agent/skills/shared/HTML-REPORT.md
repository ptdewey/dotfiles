# HTML Architecture Report Format

Architecture reviews should be rendered as a single self-contained HTML file in the OS temp directory. Tailwind and Mermaid may come from CDNs. Mermaid is best for dependency graphs and call flows; hand-built HTML/SVG is better for editorial before/after visuals.

## Output path

Resolve the temp dir from `$TMPDIR`, falling back to `/tmp` or `%TEMP%`, and write:

```txt
<tmpdir>/architecture-review-<timestamp>.html
```

Open it for the user and report the absolute path.

## Candidate card

Each candidate should include:

- **Title** — names the deepening.
- **Recommendation strength** — `Strong`, `Worth exploring`, or `Speculative`.
- **Files/packages** — concise list of involved Go packages/files.
- **Before / After diagram** — side-by-side visual.
- **Problem** — one sentence.
- **Solution** — one sentence.
- **Wins** — short bullets using locality/leverage/depth language.
- **ADR callout** — only if the candidate conflicts with an existing ADR strongly enough to revisit it.

## Visual patterns

- Call graph collapse: many caller-orchestrated functions become one deep module.
- Package surface diagram: many exported names shrink to a small exported surface with unexported internals.
- Seam diagram: concrete adapters satisfy one small consumer-owned interface.
- Cross-section: shallow packages collapse into one cohesive package.

## Tone

Use Go and architecture vocabulary precisely: package, exported surface, unexported implementation, module, interface, seam, adapter, depth, leverage, locality.

Avoid generic praise like “cleaner” or “better maintainability.” Say what improves: smaller interface, stronger locality, fewer call sites, one test surface, real adapter seam.
