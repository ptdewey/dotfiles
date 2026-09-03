# Static dotfiles

Use this directory only for stable files that cannot be expressed clearly with
native Home Manager options.

- `home/` contains files mapped explicitly beneath the home directory.
- `xdg/` contains files mapped explicitly beneath the XDG configuration root.

Do not deploy these directories wholesale. Each destination must have one
explicit owner. Application state and writable generated configuration remain
outside the repository.
