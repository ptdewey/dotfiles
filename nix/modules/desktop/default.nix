_: {
  flake.homeModules.patrick =
    { lib, pkgs, ... }:
    {
      home.file = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        ".aerospace.toml".source = ./aerospace.toml;
        ".claude/CLAUDE.md".source = ./claude/CLAUDE.md;
        ".claude/settings.json".source = ./claude/settings.json;
        ".hammerspoon".source = ./hammerspoon;
      };

      xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        "niri".source = ./niri;
        "noctalia".source = ./noctalia;
        "sway".source = ./sway;
        "waybar".source = ./waybar;
      };
    };
}
