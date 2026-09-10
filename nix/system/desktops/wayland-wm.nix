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

    # Go MPRIS media status/control binary for the waybar `custom/media` module.
    (import ./extras/waybar-mediaplayer/package.nix { pkgs = pkgs; })
    quickshell
    fnott
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    }
  ];
}
