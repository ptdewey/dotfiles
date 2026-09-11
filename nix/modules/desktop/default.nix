_: {
  flake.homeModules.patrick =
    { lib, pkgs, ... }:
    {
      home.file = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        ".aerospace.toml".source = ./aerospace.toml;
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
