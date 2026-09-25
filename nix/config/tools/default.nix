_: {
  flake.homeModules.patrick =
    {
      config,
      ...
    }:
    let
      herdrConfig = "${config.home.homeDirectory}/dotfiles/nix/config/tools/herdr/config.toml";
    in
    {
      xdg.configFile = {
        "blueprinter".source = ./blueprinter;
        "dotfiles/blueprinter/templates".source = ./blueprinter/assets/templates;
        "nix".source = ./nix;
        "nixpkgs".source = ./assets/nixpkgs;

        # These directories also contain runtime state, so only manage their
        # declarative files.
        "herdr/config.toml".source = config.lib.file.mkOutOfStoreSymlink herdrConfig;
        "jj/config.toml".source = ./jj/config.toml;
      };

    };
}
