# Repository guidance

This is a public, personal Home Manager configuration for multiple NixOS hosts
and macOS.

## Invariants

- `nix/` layout:
  - `nix/config/` — Home Manager concerns (shell, editors, terminal, desktop
    user config). Each concern is a self-registering flake-parts module.
  - `nix/modules/` — NixOS system modules that build out a machine (desktop
    sessions, display managers, apps, games, shared baseline). Plain modules,
    imported explicitly by hosts; never discovered automatically.
  - `nix/services/` — long-running / server-oriented NixOS modules
    (forgejo, jellyfin, wireguard). Imported explicitly by hosts.
  - `nix/agent/` — agent skills and subagents, self-registering flake-parts
    modules.
- Packages are installed centrally in `nix/modules/common.nix`; `nix/config/`
  concerns own configuration files only, unless documented otherwise.
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
- Agent skills are self-contained directories under `nix/agent/skills/`:
  `SKILL.md` plus optional `references/`, `scripts/`, `assets/`, `evals/`, and a
  self-registering `default.nix`. Subagent definitions live in
  `nix/agent/agents/`. Client target directories are fixed in the
  skill helper and subagent module. Client directories contain only deployed
  copies; edit the canonical asset here.
- Build before switching. The root flake is the sole configuration owner.

## Checks

Run these from the repository root:

```sh
nix fmt -- --check .
nix flake check
shellcheck nixos-switch.sh nix/config/shell/scripts/bin/*
```

Build the tracer host without activating it:

```sh
nix build --no-link .#nixosConfigurations.europa.config.system.build.toplevel
```

Do not push repository changes or activate a machine configuration unless the
user asks.
