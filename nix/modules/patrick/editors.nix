_: {
  flake.homeModules.patrick =
    { lib, pkgs, ... }:
    {
      home.file = {
        ".vimrc".source = ../../../dotfiles/home/vimrc;
        ".stylua.toml".source = ../../../dotfiles/home/stylua.toml;
      };

      xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        "harper-ls".source = ../../../dotfiles/xdg/harper-ls;
        "helix".source = ../../../dotfiles/xdg/helix;
        "zathura".source = ../../../dotfiles/xdg/zathura;
      };
    };
}
