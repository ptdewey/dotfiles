{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    (lutris.override {
      extraPkgs = pkgs: [
        pkgs.libnghttp2
        pkgs.winetricks
      ];
    })
    # wineWowPackages.waylandFull
    # wowup-cf
  ];
}
