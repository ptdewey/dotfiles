# Repository guidance

This is a public, personal Home Manager configuration for multiple NixOS hosts
and macOS.

## Invariants

- Keep host composition explicit under `nix/hosts/<platform>/<host>/`; do not
  add recursive auto-imports.
- A home-directory target has exactly one owner.
- Prefer native Home Manager options, then explicit individual file mappings.
  Do not manage writable application directories wholesale.
- Keep private runtime overrides outside the flake under
  `~/.config/dotfiles-local/`.
- Never add secrets, sessions, memories, logs, caches, sockets, or generated
  agent state.
- Agent skills are self-contained directories under `nix/modules/patrick/skills/`:
  `SKILL.md` plus optional `references/`, `scripts/`, `assets/`, `evals/`, and a
  self-registering `default.nix`. Subagent definitions live in
  `nix/modules/patrick/subagents/`. Both skill and subagent target directories
  are configured per client in `nix/modules/patrick/agents.nix`. Client directories
  contain only deployed copies; edit the canonical asset here.
- Build before switching. Do not remove the legacy setup path until a migrated
  host no longer depends on it.

## Checks

Run these from the repository root:

```sh
nix fmt -- --check .
nix flake check
shellcheck scripts/setup.sh scripts/bin/*
```

Build the tracer host without activating it:

```sh
nix run .#home-manager -- build --flake '.#patrick@europa'
```

Do not push repository changes or activate a machine configuration unless the
user asks.
