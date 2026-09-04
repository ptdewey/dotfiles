_: {
  flake.homeModules.patrick =
    { ... }:
    {
      home.file = {
        ".bashrc".source = ./bashrc;
        ".zshrc".source = ./zshrc;
        ".ignore".source = ./ignore;
        ".matcha.toml".source = ./matcha.toml;
        ".config/dotfiles/rc.sh".source = ./scripts/rc.sh;
        ".config/dotfiles/aliases.sh".source = ./scripts/aliases.sh;
        ".config/dotfiles/s3-copy.sh".source = ./scripts/s3-copy.sh;
      };
    };
}
