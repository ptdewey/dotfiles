{ ... }:
{
  xdg.configFile = {
    "blueprinter".source = ../../../dotfiles/xdg/blueprinter;
    "nix".source = ../../../dotfiles/xdg/nix;
    "nixpkgs".source = ../../../dotfiles/xdg/nixpkgs;

    # These directories also contain runtime state, so only manage their
    # declarative files.
    "herdr/.plugins.lock".source = ../../../dotfiles/xdg/herdr/.plugins.lock;
    "herdr/config.toml".source = ../../../dotfiles/xdg/herdr/config.toml;
    "jj/config.toml".source = ../../../dotfiles/xdg/jj/config.toml;
  };
}
