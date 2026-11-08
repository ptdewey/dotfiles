---
name: hit-piece
description: Adversarial code review as a hit piece: independent reviewers file findings, fresh sessions verify every claim, and unsubstantiated ones are dropped. Use after nontrivial changes, or when asked to review a diff, branch, jj revset, or GitHub PR/GitLab MR.
---

# Hit Piece

Run the binary, not caller-created review subagents. Configured Claude Code/Codex/Pi
harnesses use existing auth. Code reaches those providers; do not substitute them.
Copies are not a sandbox; tests may execute. Review trusted code.

```sh
reviewer --repo /path/to/repo --working-copy --json --progress off "Intent and risks"
```

Omit `--repo` for cwd. Choose one scope:
- `--working-copy`: tracked + nonignored untracked changes; not staged-only.
- `--base origin/main --head HEAD`: branch diff from merge base.
- `--revset '@-'`: jj revisions only.
- `--mr URL`: GitHub PR/GitLab MR.

Scopes skip planning; request-only calls a planner. Ambiguity fails noninteractively.
No `--yes` needed. Existing config required (`--config PATH`). Keep profiles unless
asked; `--profile NAME` overrides (up to two).

Over byte cap? Read largest-patch diagnostics; append narrow exclusions:
`--exclude '**/testdata/**' --exclude '**/__snapshots__/**'`.
Quote case-sensitive, root-relative Git globs: `*` stays within a directory,
`**/` matches any depth, `dir/**` excludes a subtree. No defaults/negation.
Exclude identified bulk data, not test code/all JSON. Filtering precedes the cap;
full snapshots remain readable. No synthetic commits/clones or blind cap increases.
Disclose `target.metadata.exclude_patterns` and `excluded_files`.

Capture stdout JSON on all exit codes; stderr has diagnostics. Codes: 0 no retained
findings, 1 findings, 2 incomplete/error, 130 cancelled. Empty `jobs` means no review,
including all-excluded scopes—not a clean original diff. Early errors may lack JSON.
Read `incomplete`/`errors`, then `reconciliation.groups`; `source_ids` link `jobs`,
`adjudications` hold verdicts, grounded refutations are dismissed. Uncertainty keeps
claims. Verify findings: fix, refute with evidence, or explain accepted tradeoffs.
Rerun changed code; no praise/cosmetic nits.
