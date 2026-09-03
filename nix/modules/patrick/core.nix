{
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles;
in
{
  options.dotfiles = {
    enable = lib.mkEnableOption "Patrick's shared dotfiles";

    localConfigDirectory = lib.mkOption {
      type = lib.types.str;
      default = ".config/dotfiles-local";
      description = ''
        Home-relative directory for private runtime configuration. Files in this
        directory are not Nix inputs and must be loaded only by programs that
        support runtime includes.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(lib.hasPrefix "/" cfg.localConfigDirectory);
        message = "dotfiles.localConfigDirectory must be relative to the home directory";
      }
    ];
  };
}
