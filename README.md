# dotfiles

Home Manager configuration for Patrick's machines.

The root flake exports reusable Home Manager modules for the system flake and owns the nix-darwin configuration.
Static files that cannot use native Home Manager options live under
the concern-owned assets under `nix/modules/` and are mapped individually by
the concern modules under `nix/modules/`.

Build the Home Manager module through the NixOS consumer without activating:

```sh
nix build --no-link ~/nixos#nixosConfigurations.europa.config.system.build.toplevel \
  --override-input dotfiles path:/home/patrick/dotfiles
```

Europa is activated through the Home Manager integration in `~/nixos`; this repository does not provide a second activation path.

The NixOS system configuration remains in the separate
[NixOS configuration](https://github.com/ptdewey/nixos) repository.
