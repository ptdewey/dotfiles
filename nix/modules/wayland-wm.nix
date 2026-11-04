{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    waybar
    swaybg
    xclip
    networkmanagerapplet
    bluez
    grim
    slurp
    scowl
    wofi
    pulseaudio
    playerctl
    cava
    material-symbols
    material-icons
    weather-icons
    wl-clipboard
    awww
    quickshell
    # fnott
  ];

  programs.dconf.profiles.user.databases = [
    { settings."org/gnome/desktop/interface".color-scheme = "prefer-dark"; }
  ];
}
