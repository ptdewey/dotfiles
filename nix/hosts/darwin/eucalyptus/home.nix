{ inputs, ... }:
{
  imports = [ inputs.self.homeModules.patrick ];

  home = {
    username = "patrick.dewey";
    homeDirectory = "/Users/patrick.dewey";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
