# Multi-platform flake cleanup — Design doc (arc42-lite)

**Status:** accepted
**Date:** 2026-09-03
**Authors:** Patrick Dewey and Prime Agent
**Mode:** brainstorm

## 1. Introduction and goals

The `dotfiles` repository currently acts both as a reusable Home Manager module
and as a standalone Europa Home Manager configuration. Europa also embeds the
same module through the separate `nixos` flake. This gives one home two
composition and activation routes, with different pins and collision behavior.

The target is for `dotfiles` to become Patrick's multi-platform machine flake.
It will own the new nix-darwin configuration now, continue to export reusable
Home Manager modules to the existing NixOS repository, and eventually absorb
the NixOS configurations. The immediate cleanup must not require that final
repository merge.

Top requirements:

1. Give every machine and home target one activation owner.
2. Support a nix-darwin host and Europa from one reusable Patrick home baseline.
3. Keep composition understandable while trialing `flake-parts` and
   `import-tree` as reversible choices.

### Quality goals

| Attribute | Scenario | Importance | Difficulty |
|-----------|----------|------------|------------|
| Traceability | Given a deployed target, identify its owning module and host composition without searching an unrelated asset tree. | High | Medium |
| Safety | A local edit can be built through the same composition that will activate it, and activation is never an implicit validation step. | High | Medium |
| Portability | Reuse Patrick's common home configuration on x86_64 Linux and Apple Silicon Darwin without deploying the other platform's applications. | High | High |
| Reversibility | Remove `import-tree` later by restoring explicit flake-module imports without moving modules or assets. | High | Low |
| Maintainability | Add a self-contained agent skill or program concern without updating several registries. | Medium | Medium |

### Non-goals

- Move the existing `nixos` repository into `dotfiles` during this change.
- Activate Europa or the Darwin machine as part of restructuring.
- Convert every Lua, KDL, TOML, or shell configuration into a Nix expression.
- Copy all of Hoenn's deployment, secrets, system-manager, or package-wrapper machinery.
- Manage secrets, sessions, caches, logs, sockets, generated agent state, or writable application directories.
- Decide a new `home.stateVersion` as part of the structural migration.

## 2. Constraints

- `~/nixos` remains Europa's system and activation owner until the later merge.
- `dotfiles` owns the nix-darwin configuration during the transition.
- The public module interface `homeModules.patrick` is already consumed at
  `~/nixos/hosts/europa/home.nix:18` and must either remain compatible or be
  migrated atomically with that consumer.
- Host module selection stays explicit even if module discovery is automatic.
- Use native Home Manager options first. Use exact file mappings for unsupported
  configuration, co-located with the owning concern.
- A home-directory target has exactly one owner.
- Private runtime overrides remain outside the flake under
  `~/.config/dotfiles-local/`.
- Existing uncommitted changes in `config/` and
  `nix/hosts/nixos/europa/home.nix` must not be overwritten.
- By default, `import-tree` ignores paths containing `/_`. Helpers will use this
  convention; deployable or self-registering modules will not be hidden behind
  accidental underscore paths.

## 3. Context and scope

### Prior art

- `dotfiles/flake.nix:21-39` creates a standalone Europa home configuration and
  Home Manager app, while `dotfiles/flake.nix:31` also exports
  `homeModules.patrick`.
- `~/nixos/hosts/europa/home.nix:3-20` embeds Home Manager and imports that
  exported module. This is the desired Europa activation boundary.
- `dotfiles/nix/modules/patrick/default.nix:2-11` explicitly aggregates the
  current concern modules.
- Static files are detached from their owners. For example,
  `dotfiles/nix/modules/patrick/desktop.nix:3-15` maps assets from the separate
  `dotfiles/home` and `dotfiles/xdg` trees.
- Hoenn embeds Home Manager into each system host and keeps identity at the host
  edge (`~/projects/open-source/hoenn/nix/hosts/nixos/rustboro/home.nix:3-24`).
- Hoenn uses native Home Manager options for programs such as Git
  (`~/projects/open-source/hoenn/nix/modules/aly/git.nix:8-76`) and Ghostty
  (`~/projects/open-source/hoenn/nix/modules/ghostty/default.nix:7-30`).
- Hoenn's root recursively discovers self-registering flake modules with
  `flake-parts` and `import-tree`
  (`~/projects/open-source/hoenn/flake.nix:138-153`).

### Container view

```text
+--------------------------- dotfiles repository ---------------------------+
|                                                                           |
|  flake-parts module graph <---- import-tree discovers ./nix               |
|          |                                                                |
|          +--> homeModules.patrick          (cross-platform baseline)       |
|          +--> homeModules.patrickLinux     (Linux-only concerns)           |
|          +--> homeModules.patrickDarwin    (Darwin-only concerns)          |
|          +--> darwinConfigurations.<mac>   (Darwin activation owner)       |
|          +--> checks / dev shells / formatter                             |
|                                                                           |
|  Each concern owns its Nix declaration and adjacent immutable assets.     |
+-----------------------------------+---------------------------------------+
                                    |
                                    | flake input: homeModules.*
                                    v
+---------------------------- nixos repository -----------------------------+
| nixosConfigurations.europa --> embedded Home Manager                      |
|                                (Europa activation owner)                   |
+---------------------------------------------------------------------------+
```

The eventual migration moves the lower container's NixOS hosts and modules into
the upper repository. It does not change the Home Manager module boundary.

## 4. Solution strategy

Adopt `flake-parts` and trial Hoenn-style recursive `import-tree` discovery for
self-registering modules under `nix/`. Keep final host composition explicit.
Separate the reusable home configuration into common, Linux, and Darwin module
outputs. Co-locate raw configuration with its owning concern and gradually use
native Home Manager options where they stay readable. Remove standalone Europa
Home Manager activation, but retain the module export used by `~/nixos`.

This is a **two-way door**. `flake-parts` affects output composition but not the
meaning of Home Manager modules. `import-tree` can be removed by replacing its
single recursive import with an explicit list of the same self-registering
files. No directory move should be necessary for rollback.

Y-statement: *In the context of evolving a personal Home Manager repository into
a multi-platform machine flake, facing a need for Darwin support, one activation
owner per machine, and low registry maintenance, we decided for `flake-parts`
with trial global `import-tree` discovery and against explicit registries or
deferring the architecture change, to achieve reusable self-registering modules
and an eventual combined system flake, accepting more implicit module discovery.*

## 5. Alternatives considered

### Option A — `flake-parts` with global `import-tree` discovery

Use `flake-parts` for flake composition. Recursively discover the `nix/` tree.
Every discovered `.nix` file is a flake-parts module that contributes a named
Home Manager, nix-darwin, NixOS, package, or check output. Prefix helper paths
with `_` so they are excluded by convention. Host outputs still contain visible
module lists.

Container view:

```text
flake.nix
  -> import-tree ./nix
       -> self-registering home modules
       -> self-registering Darwin host
       -> checks, packages, and development tooling
```

Y-statement: *In the context of a growing multi-platform personal flake, facing
repetitive registries and an eventual NixOS merge, we decided for global module
discovery and against explicit imports to make additions local to their concern,
accepting implicit discovery and stricter file-shape conventions.*

### Option B — `flake-parts` with explicit imports

Use `flake-parts` for multi-system and integration support, but list every flake
module explicitly in the root or a small set of aggregators. Skills retain an
explicit registry or use a narrowly scoped generated mapping.

Container view:

```text
flake.nix
  -> explicit flake-module imports
       -> named home modules
       -> named Darwin host
       -> checks, packages, and development tooling
```

Y-statement: *In the context of a growing multi-platform personal flake, facing
a need for modular outputs and easy tracing, we decided for explicit module
imports and against recursive discovery to preserve a visible dependency graph,
accepting registry maintenance.*

### Option C — Keep the direct flake until repository merge

Retain the current direct `outputs` expression. Remove standalone Europa
activation, add nix-darwin directly, and postpone `flake-parts` and
`import-tree` until NixOS moves into this repository.

Container view:

```text
flake.nix
  -> direct homeModules output
  -> direct Darwin configuration
  -> direct checks and development shell
```

Y-statement: *In the context of two machines and an incomplete repository merge,
facing scope risk, we decided for the existing direct flake and against new
composition dependencies to minimize immediate change, accepting a likely
second restructure later.*

### Tradeoff table

| Option | Evaluation latency | Activation reliability | Complexity | Operability | Cost | Reversibility | Blast radius |
|--------|--------------------|------------------------|------------|-------------|------|---------------|--------------|
| A: global discovery | Slightly higher, probably negligible at this scale | High with checks; lower if conventions are bypassed | Medium-high initially | Good after conventions settle | Two new inputs and migration work | High if files remain independently importable | Whole `nix/` module graph |
| B: explicit imports | Slightly higher, probably negligible | High; graph is visible | Medium | Best for debugging | One new framework and registry upkeep | High | Named imports only |
| C: direct flake | Lowest | High in the short term | Lowest now, medium later | Familiar but increasingly centralized | Lowest now; likely duplicate migration later | Highest | Root output expression |

**Chosen:** Option A. It aligns with the intended combined repository, supports
self-registering skill modules, and is explicitly a trial. Option B is the
fallback if discovery makes failures harder to understand.

## 6. Building blocks

### Root flake

The root `flake.nix` owns only inputs, `flake-parts` construction, supported
systems, and `import-tree` wiring. Planned inputs include `nixpkgs`,
`home-manager`, `nix-darwin`, `flake-parts`, and `import-tree`.

Supported systems initially include:

- `x86_64-linux` for Europa evaluation and development tooling.
- The Darwin host's actual architecture, expected to be `aarch64-darwin` unless
  confirmed otherwise.

### Self-registering module tree

Every non-underscored `.nix` file under `nix/` must be a valid flake-parts
module. Plain helpers and reusable functions live in a path containing `/_`.
This makes discovery rules inspectable:

- Discovered file: contributes a flake output or extends a deferred module.
- Underscored file/path: helper, never imported by discovery.
- Non-Nix file: immutable asset owned by the adjacent module.

The repository will document and test this contract. It will not add a second
custom discovery framework on top of `import-tree`.

### Home Manager module boundaries

Expose stable, named module outputs:

- `homeModules.patrick`: common shell, editor, terminal, tools, skills, and other
  genuinely cross-platform concerns.
- `homeModules.patrickLinux`: Linux-only packages, desktop configuration, and
  paths.
- `homeModules.patrickDarwin`: Aerospace, Hammerspoon, and other Darwin-only
  concerns.

If the initial migration must preserve the existing Europa consumer atomically,
`homeModules.patrick` may temporarily compose common plus Linux modules while
new explicit outputs are introduced. The final interface must avoid silently
installing both platforms' desktop configuration.

### Host composition

`nix/hosts/darwin/<host>/` owns:

- User identity and `/Users/patrick`.
- `home.stateVersion` and `system.stateVersion` compatibility baselines.
- Host-specific package/platform settings.
- An explicit list of shared Darwin and Home Manager modules.
- The `darwinConfigurations.<host>` output.

`~/nixos/hosts/europa/home.nix` continues to own Europa's Home Manager embedding,
identity, and state version. It imports the common and Linux outputs from the
`dotfiles` input.

### Program concerns and assets

Prefer a concern-oriented layout rather than a parallel target-oriented asset
tree. Illustrative shape:

```text
nix/modules/home/patrick/
├── shell/
│   ├── default.nix
│   ├── bashrc
│   └── zshrc
├── tmux/
│   ├── default.nix
│   └── tmux.conf
├── wezterm/
│   ├── default.nix
│   ├── wezterm.lua
│   └── colors/
├── niri/
│   ├── default.nix
│   └── config.kdl
└── skills/
    ├── _lib.nix
    └── architect/
        ├── default.nix
        ├── SKILL.md
        └── references/
```

The exact number of directories should follow the concern's size. A simple
native Home Manager declaration can remain one `.nix` file. A concern gets a
directory when it owns raw assets or supporting files.

### Runtime scripts and templates

Managed shell and tmux configuration must not source or execute files through a
hard-coded mutable `~/dotfiles` path. Package executable scripts into the Home
Manager generation and refer to them by installed command name or store-backed
path. Deploy template data through a declared data path and configure
Blueprinter to use that path.

Private writable hooks use `~/.config/dotfiles-local/`. Their absence must be a
supported state.

## 7. Runtime view

### Europa update

1. Edit the canonical module or adjacent asset in `dotfiles`.
2. Build Europa through the consumer flake with a local override:
   `nix build --no-link ~/nixos#nixosConfigurations.europa.config.system.build.toplevel --override-input dotfiles path:/home/patrick/dotfiles`.
3. Commit and publish the dotfiles change.
4. Update the `dotfiles` lock in `~/nixos`.
5. Build the pinned NixOS configuration.
6. Activate only after both builds succeed.

There is no standalone `hm-switch`; therefore local and deployed evaluation use
the same embedded Home Manager topology.

### Darwin update

1. Edit the canonical module or adjacent asset in `dotfiles`.
2. Run repository formatting and flake evaluation checks.
3. Build the named `darwinConfigurations.<host>` system closure on the Darwin
   machine.
4. Activate that exact configuration only after the build succeeds.

### Discovery failure

1. A new non-underscored `.nix` file is added under `nix/` with the wrong module
   shape.
2. `import-tree` discovers it and flake evaluation fails.
3. The contributor either converts it to a self-registering flake module or
   moves/renames it under an underscored helper path.
4. CI and local `nix flake check` prevent activation of the invalid graph.

## 8. Risks and technical debt

### Premortem

- **High — Tiger — surprising recursive import:** a scratch or helper `.nix`
  file changes the graph or breaks evaluation. Mitigation: one documented file
  contract, underscore exclusion, and flake checks. `mitigation_checked: no`
  until the first deliberate failure test passes.
- **High — Tiger — cross-platform leakage:** Linux-only packages or target paths
  enter the Darwin home module, or Darwin-only assets enter Europa. Mitigation:
  common/Linux/Darwin outputs plus per-platform evaluation checks.
  `mitigation_checked: no` until both host graphs evaluate.
- **High — Tiger — runtime checkout dependency survives:** shell, tmux, or
  Blueprinter still reads `~/dotfiles`, so pinned system builds are not closed.
  Mitigation: search for hard-coded checkout references and test a generation
  without relying on the checkout path. `mitigation_checked: no`.
- **Medium — Elephant — package ownership remains split:** packages continue to
  be duplicated between NixOS system packages and Home Manager. Mitigation:
  assign command-line/user tools to Home Manager and hardware/system tools to
  NixOS, with exceptions documented. `mitigation_checked: no`.
- **Medium — Elephant — public module API breaks:** restructuring renames or
  changes `homeModules.patrick` before the NixOS consumer updates. Mitigation:
  retain a compatibility output and validate with `--override-input`.
  `mitigation_checked: no`.
- **Medium — Elephant — state versions are bumped casually:** structural work
  changes compatibility behavior. Mitigation: preserve the current declared
  values during migration and review their history in an isolated decision.
  `mitigation_checked: no`.
- **Low — Paper Tiger — recursive discovery is inherently untestable:** it is
  deterministic from the source tree and can be covered by evaluation checks.
  `mitigation_checked: yes`.
- **Low — False alarm — duplicated packages duplicate Nix store bytes:** Nix
  store paths are shared. The real issue is profile ownership and divergent
  versions, not raw disk duplication. `mitigation_checked: yes`.

### Adversarial panel findings

- **SRE / 3am-on-call:** A malformed discovered file can break every output.
  Keep host builds independent where possible and ensure the fallback to
  explicit imports is documented.
- **Security:** Never respond to platform pressure by putting tokens, sessions,
  or mutable agent state in the flake. Preserve the public/private boundary and
  use encrypted secret management only when system configuration later needs it.
- **Staff-engineer skeptic:** `flake-parts` plus `import-tree` is more abstraction
  than two machines require. Its justification is the committed direction
  toward one multi-platform system repository; measure whether registry churn
  actually falls.
- **Product/owner:** Do not block Darwin onboarding on converting every legacy
  file. Move concerns in vertical slices that build on Europa and Darwin.

### Steel-man of Option B

Explicit flake-module imports may be the better long-term choice. This is a
small, personal configuration where the import list is unlikely to become a
team merge bottleneck. Explicit imports provide a direct inventory, make dead
modules obvious, and prevent a harmless scratch file from joining the module
graph. `flake-parts` still supplies the useful multi-platform output structure.
If the `import-tree` trial produces even a few hard-to-localize failures, Option
B preserves almost all of the benefit with little ongoing cost.

### What are you NOT considering?

- **Hyrum's Law:** `homeModules.patrick` is a public flake output and already has
  a consumer. Treat its current behavior as an API until both repositories are
  migrated together.
- **Chesterton's fence:** inspect every `~/dotfiles` reference before removing
  it. Some scripts and templates may rely on being writable or on relative
  paths not apparent from the parent configuration.
- **Repository boundary effects:** while two repositories exist, release and
  lock-update coordination remains manual. Local override commands reduce but
  do not eliminate that cost.
- **Darwin host facts:** CPU architecture, host name, existing Home Manager
  state version, and currently managed files must be inventoried before writing
  its composition root.
- **Application mutability:** whole-directory links may work today because an
  application never writes there. Confirm behavior before replacing them with
  individual mappings.
- **Skill portability:** fixed agent client directories may not all exist or be
  desired on Darwin. Preserve canonical sources but allow platform-appropriate
  client deployment without duplicating the skill.

## 9. Staged implementation plan

### Stage 1 — Establish one Europa activation owner

- Remove `scripts/bin/hm-switch`.
- Remove the standalone Europa `homeConfigurations` and Home Manager app from
  `flake.nix`.
- Remove `nix/hosts/nixos/europa/home.nix` after its reusable content has moved
  to the external NixOS host boundary.
- Keep `homeModules.patrick` working.
- Validate Europa with the NixOS flake and a local input override.

### Stage 2 — Introduce flake composition without moving all assets

- Add `flake-parts`, `import-tree`, and `nix-darwin` inputs.
- Convert the root flake to `flake-parts`.
- Establish the discovered-file and underscored-helper contract.
- Register existing Home Manager modules through the new graph while retaining
  compatibility for `homeModules.patrick`.
- Prove rollback by documenting the equivalent explicit import list.

### Stage 3 — Add the Darwin tracer host

- Inventory the current standalone Darwin Home Manager configuration and host
  facts.
- Add one explicit nix-darwin host composition.
- Embed Home Manager in nix-darwin; do not add a second standalone activation
  route.
- Split common, Linux, and Darwin home concerns only as required to make both
  graphs evaluate.
- Build before any requested activation.

### Stage 4 — Migrate concerns vertically

For each program or concern:

1. Choose native Home Manager options or an adjacent native file.
2. Move its assets beside the owning module.
3. Replace hard-coded `~/dotfiles` runtime references with declared packages or
   data paths.
4. Map only exact declarative targets.
5. Build Europa with the local override and evaluate/build Darwin as supported.
6. Remove the old asset only after both ownership and runtime behavior are
   verified.

Start with shell/scripts because they currently make the supposedly pinned
module depend on a mutable checkout. Follow with tmux and Blueprinter, then
program configs. Treat skills as their own slice because their fan-out contract
is distinct.

### Stage 5 — Clarify package and platform ownership

- Move user CLI and development tools to Home Manager by default.
- Keep boot, hardware, drivers, system services, and shared machine facilities
  in NixOS/nix-darwin.
- Remove duplicates only after confirming no other NixOS user depends on the
  system package.
- Add evaluation/build checks for every exported host and stable module output.

### Later — Upstream NixOS

Move NixOS hosts and modules into `dotfiles`, make the repository the sole
system flake, migrate secrets without exposing plaintext, update activation
commands, then retire the old NixOS repository. This later change should get its
own decision record because it has a wider blast radius.

## 10. Verification criteria

- `nix fmt -- --check .` succeeds.
- `nix flake check` succeeds on a supported local platform.
- The Europa toplevel builds through `~/nixos` with the local dotfiles override.
- The pinned Europa toplevel builds after updating the NixOS input lock.
- The Darwin configuration evaluates, and its system closure builds on the
  Darwin host before activation.
- `rg '~/dotfiles|\$HOME/dotfiles'` finds no runtime dependency in managed
  configuration, except clearly documented development commands.
- Linux composition does not own Darwin-only targets; Darwin composition does
  not own Linux-only targets.
- No standalone `homeConfigurations."patrick@europa"` or `hm-switch` remains.
- Adding a malformed discovered `.nix` file causes a check failure; moving it to
  an underscored helper path excludes it as documented.
- Replacing `import-tree` with the documented explicit module list yields the
  same named flake outputs.
- `shellcheck scripts/bin/*` succeeds for the scripts that remain.
- No secrets, sessions, logs, caches, sockets, or generated state are added.

## 11. Decision log

- **Decision:** adopt Option A, with Option B as the documented fallback.
- **Door type:** two-way.
- **Strongest rejected alternative:** `flake-parts` with explicit imports.
- **Decision status:** accepted; implementation not yet started.
- **Open questions:** Darwin host name and architecture; exact preservation value
  for `home.stateVersion`; which agent clients should be deployed on Darwin.
- **Follow-up decisions:** NixOS repository merge; secret management in the
  combined system flake; whether the `import-tree` trial met its success bar.
