_: {
  flake.homeModules.patrick =
    { ... }:
    {
      xdg.configFile = {
        "blueprinter".source = ./blueprinter;
        "dotfiles/blueprinter/templates".source = ./blueprinter/assets/templates;
        "nix".source = ./nix;
        "nixpkgs".source = ./assets/nixpkgs;

        # These directories also contain runtime state, so only manage their
        # declarative files.
        "herdr/config.toml".source = ./herdr/config.toml;
        "jj/config.toml".source = ./jj/config.toml;
      };
    };
}
