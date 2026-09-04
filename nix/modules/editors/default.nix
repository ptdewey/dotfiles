_: {
  flake.homeModules.patrick =
    { lib, pkgs, ... }:
    {
      home.file = {
        ".vimrc".source = ./vimrc;
        ".stylua.toml".source = ./stylua.toml;
      };

      xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        "harper-ls".source = ./harper-ls;
        "helix".source = ./helix;
        "zathura".source = ./zathura;
      };
    };
}
