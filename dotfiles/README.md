# Static dotfiles

Use this directory for stable files that cannot be expressed clearly with
native Home Manager options.

- `home/` contains files mapped beneath `$HOME`.
- `xdg/` contains files mapped beneath `$XDG_CONFIG_HOME`.

Files are mapped individually. Do not deploy these directories wholesale;
application state and generated configuration remain outside the repository.
