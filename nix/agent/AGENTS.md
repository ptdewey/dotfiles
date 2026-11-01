# Global conventions

Before each message send a kaomoji that represents how you feel then.

## Version control: Jujutsu (jj), not git

In many of my projects, I use jj, not git. Before running any VCS command, check for a `.jj/` directory. If `.jj/` is present, use jj.

Common mappings I use:

- `jj st` — status (use instead of `git status`)
- `jj diff` / `jj diff -r <rev>` — diff
- `jj desc -m "msg"` — set description on current change (like commit message)
- `jj new` — start new change on top
- `jj edit @-` — move working copy to parent
- `jj squash` — fold current change into parent; I often run `jj squash && jj edit @-` as a pair
- `jj bookmark set <name> -r @-` — move bookmark (like `git branch -f`)
- `jj git push` — push; add `--allow-new` for first push of a new bookmark
- `jj git fetch` — fetch
- `jj restore <path>` — undo file changes (use instead of `git checkout --`); agents must not use this unless the user explicitly asks to revert changes
- `jj op log` / `jj op restore <id>` — rewind the whole repo state

Shipping sequence I typically use: `jj desc -m …` → `jj bookmark set <name> -r @` → `jj git push` (with `--allow-new` if new) → `jj new`.

Do not suggest `git add`, `git commit`, `git stash`, `git checkout`, `git reset`, or `git rebase` in a jj workspace.

Treat unrelated existing changes as read-only unless told otherwise; the user or another agent may have made them. If you are working on the same code, preserve unrelated edits while making the needed change.

Make atomic, bisectable commits: one logical change per commit.
Don't mix unrelated changes or bundle refactors with behavior changes.
Each commit should build and pass tests so bisect can pinpoint regressions.

## Use Go Tooling Effectively

When working in Go codebases, always do the following:

- To see source files from a dependency, or to answer questions
  about a dependency, run `go mod download -json MODULE` and use
  the returned `Dir` path to read the files.

- Use `go doc foo.Bar` or `go doc -all foo` to read documentation
  for packages, types, functions, etc.

- Use `go run .` or `go run ./cmd/foo` instead of `go build` to
  run programs, to avoid leaving behind build artifacts.

## Code comments

Default to no new implementation comments.

Prefer clear names, small functions, explicit types, and extracted helpers over
comments. Before adding a comment, first consider whether the code can be made
self-explanatory.

A comment is justified only when it records information the code cannot express:

- The rationale or trade-off behind a non-obvious decision.
- A non-obvious invariant, precondition, or correctness constraint.
- An external API, protocol, compatibility, vendor, or platform limitation.
- A security or performance decision whose motivation is not apparent.
- Required public API documentation.
- A concise explanation of unusually difficult mathematics or algorithms.

Do not add comments that:

- Narrate control flow or restate the following code.
- Describe assignments, loops, conditionals, returns, or function calls.
- Use headings such as "Step 1", "Initialize", "Process", or "Handle result".
- Record task history, recent changes, or what was "added" or "updated".
- Compensate for unclear naming or unnecessarily complicated structure.
- Leave dead or previous code commented out.
- Add boilerplate docstrings to private functions whose signature is sufficient.
- Label test sections with Arrange, Act, or Assert unless the repository requires it.

When modifying existing code, preserve useful comments but remove comments made
obsolete by your change.

Before finishing, inspect the comments added in the git diff. Delete every new
comment that does not satisfy one of the allowed cases above.
