{ inputs, pkgs, ... }:
let
  homeManagerBackup = pkgs.writeShellApplication {
    name = "home-manager-backup";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      source_path="$1"
      backup_root="''${XDG_DATA_HOME:-$HOME/.local/share}/home-manager/backups"

      if [[ "$source_path" == "$HOME/"* ]]; then
        relative_path="''${source_path#"$HOME/"}"
      else
        relative_path="absolute/''${source_path#/}"
      fi

      timestamp="$(date --utc +%Y%m%dT%H%M%S.%NZ)-$$"
      destination="$backup_root/$relative_path/$timestamp"

      mkdir -p -- "$(dirname -- "$destination")"
      mv -- "$source_path" "$destination"
    '';
  };
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    backupCommand = "${homeManagerBackup}/bin/home-manager-backup";
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.patrick = {
      home = {
        homeDirectory = "/home/patrick";
        stateVersion = "26.05";
        username = "patrick";
      };

      imports = [ inputs.self.homeModules.patrick ];

      programs.home-manager.enable = true;
    };
  };
}
