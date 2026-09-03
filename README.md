# dotfiles

Home Manager configuration for Patrick's machines.

The root flake owns the Home Manager configuration for `patrick@europa`.
Static files that cannot use native Home Manager options live under
`dotfiles/home/` and `dotfiles/xdg/` and are mapped individually by
`nix/modules/patrick/files.nix`.

Build without activating:

```sh
nix run .#home-manager -- build --flake '.#patrick@europa'
```

Switch the active configuration:

```sh
scripts/bin/hm-switch
```

The NixOS system configuration remains in the separate
[NixOS configuration](https://github.com/ptdewey/nixos) repository.
