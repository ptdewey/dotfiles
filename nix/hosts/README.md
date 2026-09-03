# Home Manager hosts

Hosts are organized by platform, mirroring Hoenn: `nix/hosts/nixos/<host>/`,
`nix/hosts/darwin/<host>/`, and later `nix/hosts/system-manager/<host>/` if
needed. Each host directory is an explicit composition root that imports
`nix/modules/patrick` and records only harmless, public exceptions.

Username and home directory are per-host facts declared in `flake.nix`
(`mkHome { ... }`), so machines with different account names share the same
`modules/patrick` tree. Add a matching `homeConfigurations."<user>@<host>"`
entry in `flake.nix` for each new host.

Keep private values out of these modules. Runtime-local configuration belongs
below `~/.config/dotfiles-local/`; private NixOS configuration remains in the
private system flake.
