{ pkgs, ... }:
{
  home.file = {
    ".local/share/fonts/custom".source = ../../../fonts;
    ".local/share/icons/bibata".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
  };
}
