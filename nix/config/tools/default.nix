_: {
  flake.homeModules.patrick =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      herdrConfig = "${config.home.homeDirectory}/dotfiles/nix/config/tools/herdr/config.toml";
      reloadHerdrConfig = pkgs.writeShellScript "reload-herdr-config" ''
        if ${lib.getExe pkgs.herdr} status server | ${lib.getExe pkgs.gnugrep} -q '^status: running$'; then
          exec ${lib.getExe pkgs.herdr} server reload-config
        fi
      '';
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

      systemd.user = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        paths.herdr-config-reload = {
          Unit.Description = "Watch the Herdr configuration";
          Path.PathChanged = herdrConfig;
          Install.WantedBy = [ "default.target" ];
        };

        services.herdr-config-reload = {
          Unit.Description = "Reload the Herdr configuration";
          Service = {
            Type = "oneshot";
            ExecStart = reloadHerdrConfig;
          };
        };
      };
    };
}
