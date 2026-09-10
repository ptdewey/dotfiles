# dotfiles

This repository contains my multi-platform machine configuration. Home Manager
owns user configuration such as tmux, shells, terminal tools, and coding-agent
assets. NixOS host composition lives under `nix/hosts/nixos/`.

Neovim configuration lives in a separate repository.

Build and switch the NixOS configuration for the current host from the repository
root:

```sh
./nixos-switch.sh
```

The script refuses to switch a configuration whose declared hostname does not
match the current machine.
