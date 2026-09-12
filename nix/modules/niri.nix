{ pkgs, ... }:

{
  imports = [ ./wayland-wm.nix ];

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    swaylock
    fuzzel
    xwayland-run
  ];

  systemd.user.services = {
    swaybg = {
      description = "Wallpaper Service";
      after = [ "niri.service" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i %h/Pictures/wallpapers/ghibli-city.jpeg";
        Restart = "on-failure";
      };
    };

    # swww-daemon = {
    #   description = "Animated Wallpaper Daemon";
    #   after = [ "niri.service" ];
    #   wantedBy = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.swww}/bin/swww-daemon";
    #     Restart = "on-failure";
    #   };
    # };

    # swww = {
    #   description = "Animated Wallpaper Setter";
    #   after = ["swww-dameon.service"];
    #   wantedBy = ["graphical-session.target"];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.swww}/bin/swww --restore";
    #     Restart = "on-failure";
    #   };
    # };
  };
}
