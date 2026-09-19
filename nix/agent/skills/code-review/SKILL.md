---
name: code-review
description: Review a change (a merge/pull request, or the current branch/jj change) with TWO parallel reviewer subagents — a standard reviewer and an adversarial reviewer. Use when the user requests a code review, or at most once as a final quality check after the agent changes code. Never repeat automatically; iterative fix-and-review cycles require an explicit user request.
disable-model-invocation: false
tags:
  - productivity
polytoken: true
---

# Code Review

Orchestrate a two-reviewer code review. The main agent does **not** review the diff itself — it dispatches two reviewer **subagents** that run concurrently, waits for **both** to return, merges their findings, and delivers a single review.

**One pass is the default.** If this skill was selected automatically, run it no more than once for the user's task. Do not re-invoke it after fixes. Repeated fix-and-review cycles are allowed only when the user explicitly asks for iteration, such as "fix and re-review until clean."

Host- and VCS-agnostic: works in **jj** and **git** repos, and against **GitLab**, **GitHub**, or no remote at all. The guaranteed deliverable is an **in-chat** review; posting to a remote MR/PR is optional and gated on consent.

> **Subagents — non-negotiable.**
> - The review reasoning runs **inside subagents, never in the main agent.** Dispatch **exactly two** subagents in a **single assistant turn** so they run in parallel.
> - One is the **standard reviewer**, one is the **adversarial reviewer**. Both get the same context bundle.
> - The main agent only orchestrates: gather context → dispatch the two → wait for both → merge → deliver → optionally act according to the policy below.
> - Model is the harness default — no model pinning. Whatever subagent tool the harness provides (`Task`, `Agent`, `subagent`) is fine; dispatch both in one turn.

## Policy — decide this first

Determine both ownership and repetition policy:

- **Authoring mode** — *you wrote the changes under review.* You may fix findings when the surrounding task already authorizes implementation, but the default remains one review pass.
- **External mode** — *you're reviewing someone else's work.* **Read-only**: deliver feedback and never edit their code.
- **Single-pass policy (default)** — applies to every automatic invocation and ordinary review request. Run one two-reviewer pass, deliver it, optionally fix findings when already authorized, and stop. **Never re-invoke the skill.**
- **Iterative policy (explicit opt-in only)** — use only when the user clearly asks to fix and re-review repeatedly or to continue until clean. A request merely to "review" is not opt-in to iteration.

If ownership is ambiguous, ask one clarifying question before reviewing. If repetition policy is ambiguous, choose single-pass; do not ask merely to enable a loop.

## The Flow

```
identify target + ownership + repetition policy
        │
        ▼
detect VCS (jj vs git) + gather diff + context  (main agent)
        │
        ▼
dispatch TWO reviewer subagents in ONE turn — parallel:
   • standard reviewer            • adversarial reviewer
        │
        ▼
WAIT for BOTH to return   ◄── deliver / post / fix NOTHING until both terminal
        │
        ▼
merge + dedupe findings → one severity-ranked review
        │
        ▼
deliver: in-chat summary (always) + post only if open MR/PR & consent
        │
        ▼
external → done
authoring + single-pass → optionally fix if authorized, then done
authoring + explicit iterative policy → fix, test, and re-review (cap 5)
```

## Steps

### 1. Identify the target and policy

- **Target:** an MR/PR the user named; otherwise the current work vs. the repo's base.
- **Ownership:** *authoring* if you wrote the changes (your working change/branch, or an MR/PR you authored); *external* if you didn't. If ownership is unclear, ask one question.
- **Repetition:** *single-pass* unless the user explicitly requested iterative fix-and-review cycles. Automatic invocation is always single-pass.

### 2. Detect the VCS and gather the diff + context (main agent)

Detect which VCS this repo uses, then gather the diff with the matching tool. This is cheap orchestration work.

```bash
test -d .jj && echo jj || echo git
```

**jj repos** (base defaults to `trunk()`):

```bash
jj log    -r 'trunk()..@'                 # commits in this stack
jj diff   --from 'trunk()' --to '@' --name-only   # changed files
jj diff   --from 'trunk()' --to '@'               # full diff
```

If the change isn't rooted at `trunk()`, use the fork point instead: `--from 'fork_point(trunk() | @)'`.

**git repos** (resolve base agnostically — don't assume `main`):

```bash
BASE=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
BASE=${BASE:-main}
git fetch origin "$BASE" --quiet
git log  "origin/$BASE..HEAD" --oneline        # commits
git diff "origin/$BASE...HEAD" --name-only     # changed files
git diff "origin/$BASE...HEAD"                  # full diff
```

**If an MR/PR exists**, pull its title/body (intent) with whatever host CLI is available — `glab mr view <id>` (GitLab) or `gh pr view <id>` (GitHub). If neither is installed, skip it and rely on the diff + commit messages.

Assemble a **context bundle** for both subagents: changed-files list, commit log, the full diff, the MR/PR intent (if any), and the touched subsystem/prefix.

### 3. Dispatch the two reviewer subagents — parallel

In a **single assistant turn**, spawn **two** general-purpose subagents (harness default model). Hand each the full context bundle and tell it: **read-only on source** (it may read files / run `jj diff` or `git diff` to dig deeper, but must not modify code or repo state — no `jj restore`/`jj abandon`, no `git checkout`/`reset`); return findings as its result in the format below.

**Reviewer A — Standard.** A balanced, thorough review across, in priority order:
1. Correctness & logic (does it do what the change claims?)
2. Edge cases & error handling
3. Security (injection, authz/authn, secrets, unvalidated trust-boundary input)
4. Concurrency (races, shared mutable state, cancellation)
5. Performance & resource use (N+1s, unbounded growth, hot-path cost)
6. API & compatibility (breaking signatures/schemas, migration safety)
7. Tests (is the new behavior covered? tests that would fail before the change?)
8. Readability & maintainability (nits, lowest priority)
Also call out **what's good**.

**Reviewer B — Adversarial.** Assume the change is subtly broken and *try to break it.* Hunt the worst-case: the exploitable security hole, the race, the malformed/hostile input that isn't handled, the invariant the author assumed but didn't enforce, the edge case the happy-path tests skip. Be skeptical of the tests themselves — do they actually pin the contract, or do they pass vacuously? Prefer one real, well-argued blocker over ten nits.

**Finding format (both reviewers):** a one-line verdict, then each finding as `severity · path:line — problem → why it matters → fix direction`. Severity scale: `Blocker · High · Medium · Low · Nit`. Use the diff's new-side line numbers. No hypotheticals stated as fact — unverifiable downstream effects are marked "unverified".

### 4. Wait for BOTH, then merge (main agent)

- Wait until **both** subagents are terminal. **Deliver nothing, post nothing, fix nothing until both have returned** — no acting on whichever finished first.
- **Merge, don't concatenate:** dedupe overlapping findings (same `path:line` / same issue), keep the higher severity, and tag each finding's source — `standard`, `adversarial`, or `both`. Adversarial-only findings are usually the subtle ones; don't drop them.
- Build one unified review: verdict line, a severity-ranked table (`Severity | path:line | source | one-liner`), the per-finding detail, and a "what's good" note when warranted.

### 5. Deliver the merged review (after both returned)

- **Always** print the merged review in chat — this is the guaranteed deliverable. Default to chat only.
- **Posting is optional and gated:** only if an **open** MR/PR exists **and** the user consents. No open MR/PR → summary only, don't ask. If one is open, ask whether to post (show its number/URL); default to not posting.
- On consent, post **comment/note only** (never approve or request-changes unless asked), prefixing every comment with `Claude: `. Use whichever host CLI is present:
  - GitLab: `glab mr note <id> -m "Claude: <verdict + severity table>"` (per-line discussions via `glab api`).
  - GitHub: `gh pr comment <id> --body "Claude: <verdict + severity table>"` (per-line via `gh api .../comments`).
  - Neither CLI available: **emit the fully-formatted note text in chat** for the user to paste. Do not invent a posting path.

### 6. After the review

- **External mode:** stop after step 5. Never edit someone else's code and never iterate on their behalf.
- **Authoring + review-only request:** stop after step 5. A request to review does not itself authorize edits.
- **Authoring + implementation already authorized:** if the merged review has findings, you may fix them once:
  1. Fix **root causes** — no workarounds, no disabling/skipping tests, no `--no-verify`.
  2. Add or adjust a test that **would have failed before** the fix, pinning the contract.
  3. Run the relevant test suite + lint; fix any breakage before continuing.
  4. In a jj repo, let jj snapshot the working copy — do **not** stage, and do **not** push (`jj git push` is the user's to run). Leave unrelated in-flight changes alone.
  5. Under the **single-pass policy**, report the fixes and stop. Do not re-invoke this skill to check them.
- Under the **iterative policy only**, re-invoke from step 2 after fixes and repeat until a cycle returns no new findings.
- **Iterative-policy guardrails:**
  - Print `Code-review cycle N` at the top of each pass so progress is visible.
  - **Cap: 5 cycles.** If still not clean after 5, stop and hand back with the current findings.
  - **Same finding twice in a row = stop and ask** — the fix isn't fixing it; don't churn variations.

## Rules

- **Reviewing happens in subagents, never the main agent.** Exactly two, dispatched in one turn so they run in parallel: standard + adversarial. Harness-default model; no model pinning.
- **No feedback before both return.** Don't deliver, post, or start fixing until both subagents are terminal. No partial reviews.
- **Merge, don't staple.** Dedupe, keep the higher severity, keep adversarial-only findings, tag sources.
- **One pass by default.** Automatic invocation is always single-pass. Ordinary review requests are also single-pass. Only an explicit request for repeated fix-and-review cycles enables re-invocation.
- **Ownership gates edits.** External → read-only. Authoring → fix only when the surrounding request authorizes implementation; a review-only request does not.
- **Chat first; posting needs an open MR/PR + explicit consent.** Comment/note-only, `Claude: ` prefix, host CLI auto-detected. No CLI → emit the note text to paste. No open MR/PR → summary only.
- **Respect the VCS.** jj repos: use jj, never `git add/commit/checkout/reset`; never push; never `jj restore`/`jj abandon` unless the user asks to revert.
- **Fix root causes; tests gate fixes.** When iteration was explicitly requested, cap it at 5 cycles; same finding twice → stop and ask.
- **Ground every finding in code** (`path:line`); mark unverifiable downstream effects "unverified". Severity is your honest read — don't inflate nits or hedge a real blocker.

## Quick reference

| Phase | Who | Output |
|-------|-----|--------|
| Identify + detect VCS + gather (1–2) | main agent | context bundle + ownership/repetition policy |
| Review (3) | **2 subagents, parallel** | two finding sets |
| Wait + merge (4) | main agent | one severity-ranked review |
| Deliver (5) | main agent | chat summary always; post if open MR/PR + consent |
| Act (6, authoring only) | main agent | optional fixes; re-review only on explicit opt-in (cap 5) |

## Notes for the operator

- **Two reviewers, run together:** the adversarial pass catches what the balanced pass rationalizes away. Running them concurrently (not one after the other) keeps it fast and keeps the merge honest.
- **Wait-for-both** exists so you never act on half a review — a blocker from the slower reviewer shouldn't be missed because the other finished first.
- **Automatic means once.** A model-selected quality check must not turn one implementation request into an open-ended review loop.
- **Iteration is user-controlled.** When explicitly requested, each cycle re-invokes the whole skill for a fresh, unbiased two-reviewer pass on the latest code.
- **External mode is deliberately read-only** — reviewing someone else's work never edits their branch.
- **Chat is the contract.** The remote MR/PR post is a convenience; the in-chat review is always produced, so the skill is useful even with no remote and no host CLI.
