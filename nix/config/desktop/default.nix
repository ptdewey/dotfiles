_: {
  flake.homeModules.patrick =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      niriConfig = "${config.home.homeDirectory}/dotfiles/nix/config/desktop/niri/config.kdl";
      noctaliaConfig = "${config.home.homeDirectory}/dotfiles/nix/config/desktop/noctalia/config.toml";
    in
    {
      home.file = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        ".aerospace.toml".source = ./aerospace.toml;
        ".hammerspoon".source = ./hammerspoon;
      };

      # Migrate the previous whole-directory Home Manager links before creating
      # the individually managed links below. Without this, linkGeneration tries
      # to modify children of immutable Nix store directories.
      home.activation.migrateDesktopConfigDirectories = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
        lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] ''
          niri_config_dir=${lib.escapeShellArg "${config.xdg.configHome}/niri"}
          noctalia_config_dir=${lib.escapeShellArg "${config.xdg.configHome}/noctalia"}

          if [[ -L "$niri_config_dir" ]]; then
            resolved="$(${pkgs.coreutils}/bin/readlink -f -- "$niri_config_dir")"
            case "$resolved" in
              /nix/store/*-hm_niri)
                $DRY_RUN_CMD ${pkgs.coreutils}/bin/rm -- "$niri_config_dir"
                $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p -- "$niri_config_dir"
                ;;
              *)
                echo "Refusing to replace unexpected Niri config symlink: $niri_config_dir -> $resolved" >&2
                exit 1
                ;;
            esac
          fi

          if [[ -L "$noctalia_config_dir" ]]; then
            resolved="$(${pkgs.coreutils}/bin/readlink -f -- "$noctalia_config_dir")"
            case "$resolved" in
              /nix/store/*-hm_noctalia)
                $DRY_RUN_CMD ${pkgs.coreutils}/bin/rm -- "$noctalia_config_dir"
                $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p -- "$noctalia_config_dir"
                ;;
              *)
                echo "Refusing to replace unexpected Noctalia config symlink: $noctalia_config_dir -> $resolved" >&2
                exit 1
                ;;
            esac
          fi
        ''
      );

      home.activation.validateNoctaliaConfig = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
        lib.hm.dag.entryBefore [ "writeBoundary" ] ''
          ${lib.getExe pkgs.noctalia} config validate ${lib.escapeShellArg noctaliaConfig}
        ''
      );

      xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        # Keep live-reloaded application configuration editable outside the
        # Nix store. Home Manager owns the target paths, not the file contents.
        "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink niriConfig;
        "noctalia/config.toml".source = config.lib.file.mkOutOfStoreSymlink noctaliaConfig;
        "sway".source = ./sway;
        "waybar".source = ./waybar;
      };
    };
}
