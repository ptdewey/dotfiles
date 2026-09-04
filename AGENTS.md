# Repository guidance

This is a public, personal Home Manager configuration for multiple NixOS hosts
and macOS.

## Invariants

- Keep host composition explicit under `nix/hosts/<platform>/<host>/`; do not
  add recursive auto-imports.
- A home-directory target has exactly one owner.
- Prefer native Home Manager options, then explicit individual file mappings
  in the concern module that owns each target. Do not manage writable
  application directories wholesale.
- Keep private runtime overrides outside the flake under
  `~/.config/dotfiles-local/`.
- Never add secrets, sessions, memories, logs, caches, sockets, or generated
  agent state.
- Agent skills are self-contained directories under `nix/modules/skills/`:
  `SKILL.md` plus optional `references/`, `scripts/`, `assets/`, `evals/`, and a
  self-registering `default.nix`. Subagent definitions live in
  `nix/modules/subagents/`. Client target directories are fixed in the
  skill helper and subagent module. Client directories contain only deployed
  copies; edit the canonical asset here.
- Build before switching. The root flake is the sole configuration owner.

## Checks

Run these from the repository root:

```sh
nix fmt -- --check .
nix flake check
shellcheck scripts/bin/*
```

Build the tracer host without activating it:

```sh
nix build --no-link ~/nixos#nixosConfigurations.europa.config.system.build.toplevel --override-input dotfiles path:/home/patrick/dotfiles
```

Do not push repository changes or activate a machine configuration unless the
user asks.
