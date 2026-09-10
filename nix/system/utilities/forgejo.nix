{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    forgejo-cli
  ];

  services.forgejo = {
    enable = true;
    stateDir = "/var/lib/forgejo";
    database.type = "postgres";
    repositoryRoot = "/vault/git";
    settings = {
      server = {
        DOMAIN = "10.0.0.71";
        # ROOT_URL = "${config.DOMAIN}/${config.HTTP_PORT}";
        HTTP_PORT = 21975;
      };
    };
  };
}
