{ ... }:

{
  services.seatd.enable = true;
  programs.river-classic.enable = true;
  users.users.patrick.extraGroups = [
    "seat"
    "video"
    "input"
  ];
}
