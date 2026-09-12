# Host configurations

This repository owns reusable Home Manager modules and the explicit composition
roots for each machine.

NixOS hosts live under `nix/hosts/nixos/<host>/`. Standalone Home Manager
hosts live under `nix/hosts/darwin/<host>/`. System modules live under
`nix/modules/` and long-running services under `nix/services/`; both are
plain NixOS modules imported explicitly by hosts, outside the recursively
discovered flake-parts module tree. Home Manager concerns live under
`nix/config/` and agent assets under `nix/agent/`; both self-register into
the `patrick` home profile through recursive discovery.

The NixOS configurations were imported as a snapshot from
[`ptdewey/nixos`](https://github.com/ptdewey/nixos) at commit
`e2666e090fed03a14483029a9bae89f471e4426a`. The original repository retains its
full history.

Host-specific public exceptions belong in the host module. Private runtime
configuration stays outside the flake under `~/.config/dotfiles-local/`.
