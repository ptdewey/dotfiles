{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.enable = true;
  # networking.wg-quick.interfaces.kelsier.configFile = "/home/patrick/nixos/wireGuardShare.conf";
}
