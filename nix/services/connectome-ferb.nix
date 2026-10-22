{ pkgs, ... }:

let
  host = "/data-staging/connectome-ferb/releases/2026-10-12-host-0.9.0";
in
{
  users.groups.ferb = { };
  users.users.ferb = {
    isSystemUser = true;
    group = "ferb";
    home = "/var/lib/ferb";
    createHome = true;
    shell = "${pkgs.shadow}/bin/nologin";
  };

  systemd.services.connectome-ferb = {
    description = "Ferb Connectome resident";
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = "/data-staging/connectome-ferb/recipe.json";
    unitConfig.RequiresMountsFor = [ "/data" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    path = with pkgs; [
      bun
      nodejs_24
      codex
      git
      openssh
      ripgrep
      fd
      jq
      curl
      coreutils
      findutils
      gnugrep
      gnused
      gawk
      diffutils
      patch
      gnutar
      gzip
      unzip
      zip
      tree
      gnumake
      gcc
      python3
    ];

    environment = {
      HOME = "/var/lib/ferb";
      DATA_DIR = "/var/lib/ferb/data";
      CODEX_HOME = "/var/lib/ferb/.codex";
      CODEX_BINARY = "${pkgs.codex}/bin/codex";
    };

    serviceConfig = {
      Type = "simple";
      User = "ferb";
      Group = "ferb";
      WorkingDirectory = host;
      ExecStart = "${pkgs.bun}/bin/bun ${host}/src/index.ts /data-staging/connectome-ferb/recipe.json --headless";
      StateDirectory = "ferb";
      StateDirectoryMode = "0700";
      EnvironmentFile = "/var/lib/ferb/webui.env";
      UMask = "0077";
      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      InaccessiblePaths = [
        "/data-staging/models"
        "/data/models"
      ];
      ReadWritePaths = [
        "/var/lib/ferb"
        "/data-staging/projects"
        "/data/projects"
      ];
    };
  };
}
