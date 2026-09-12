_: {
  flake.homeModules.patrick =
    { lib, pkgs, ... }:
    {
      home.file = {
        ".local/share/fonts/custom".source = ./assets;
        ".local/share/icons/bibata" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
        };
      };
    };
}
