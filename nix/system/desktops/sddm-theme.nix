# sddm theme
{ pkgs, ... }:

let
  sddmTheme = pkgs.stdenv.mkDerivation {
    name = "sddm-theme";
    src = pkgs.fetchFromGitHub {
      owner = "Keyitdev";
      repo = "sddm-astronaut-theme";
      rev = "468a100460d5feaa701c2215c737b55789cba0fc";
      sha256 = "1h20b7n6a4pbqnrj22y8v5gc01zxs58lck3bipmgkpyp52ip3vig";
    };
    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
    '';
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${sddmTheme}";
  };
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtgraphicaleffects
  ];
}
