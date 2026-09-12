---
name: jj-workflow
description: Jujutsu (jj) version control workflows. Use when working in repos with .jj/ directory instead of git. Covers commands, revsets, workspaces, and conflict resolution.
---

# Jujutsu (jj) Workflow

## Detection

Check for `.jj/` directory to determine if a repo uses jj:

```bash
test -d .jj && echo "jj repo" || echo "not jj"
```

## Agent Rules

When working in jj repos:

1. **Use jj, not git** - Don't use `git add`, `git commit`, `git stash`, `git checkout`, `git reset`, or `git rebase`
2. **Describe changes plainly** - Do not prefix descriptions with `wip:` unless the change is explicitly experimental or the user asks for it
3. **Never push** - Leave `jj git push` to the user
4. **No staging area** - jj snapshots the working copy automatically, there's no `git add`
5. **Don't revert unless asked** - Do not use `jj restore` or `jj abandon` unless the user explicitly asks you to revert changes. In parallel agent runs, status may include another agent's work.
6. **Preserve unrelated edits** - Treat unrelated existing changes as read-only unless told otherwise; if touching the same code, preserve unrelated edits while making the requested change.

## Core Concepts

### Changes vs Commits

- jj uses "changes" - mutable until pushed
- Working copy is always a change (shown as `@`)
- No staging area - all file modifications are automatically tracked

### Revisions

- `@` - current working copy change
- `@-` - parent of current change
- `@--` - grandparent
- `root()` - root of the repo

## Command Reference

### Status & Diffs

```bash
jj st                    # Status (like git status)
jj diff                  # Diff of current change
jj diff -r @-            # Diff of parent change
jj diff -r REV           # Diff of specific revision
```

### History

```bash
jj log                   # Show history
jj log -r @::            # Current change and descendants
jj log -r ::@            # Current change and ancestors
```

### Making Changes

```bash
jj new                   # Start a new change on top of current
jj desc -m "msg"         # Set description
jj edit @-               # Move working copy to parent
jj squash                # Fold current change into parent
```

### Common Patterns

```bash
# Fold and continue editing parent
jj squash && jj edit @-

# Abandon current change - only when the user explicitly asked to revert
jj abandon --pi-user-requested-revert

# Restore file to previous state - only when the user explicitly asked to revert
jj restore <path> --pi-user-requested-revert
```

### Bookmarks (like git branches)

```bash
jj bookmark list                    # List bookmarks
jj bookmark set <name> -r @         # Set bookmark at current change
jj bookmark delete <name>           # Delete bookmark
```

### Git Interop

```bash
jj git fetch             # Fetch from remote
jj git push              # Push (USER ONLY - agent should not run this)
jj git push --allow-new  # Push new bookmark (USER ONLY)
```

### Recovery with Op Log

jj tracks all operations. You can undo almost anything:

```bash
jj op log                # Show operation history
jj op restore <id>       # Restore repo to previous state
```

## Workspaces

Workspaces let you work on multiple changes in parallel (similar to git worktrees):

```bash
jj workspace list                           # List workspaces
jj workspace add ../path-to-workspace       # Create new workspace
jj workspace add ../path name               # Create with specific name
jj workspace forget <name>                  # Remove workspace
```

Each workspace has its own working copy but shares the repo history.

## Conflict Resolution

When conflicts occur:

```bash
jj st                    # Shows conflicted files
jj diff                  # Shows conflict markers
# Edit files to resolve
jj st                    # Verify resolved
```

## User's Shipping Sequence (Reference Only)

The user handles shipping themselves:

```bash
jj desc -m "final message"        # Write final commit message
jj bookmark set <name> -r @       # Set bookmark  
jj git push                       # Push (--allow-new if new bookmark)
jj new                            # Start next change
```

**Agent should not run the push step.**
