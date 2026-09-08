_: {
  flake.homeModules.patrick =
    { ... }:
    {
      home.file = {
        ".bashrc".source = ./bashrc;
        ".zshrc".source = ./zshrc;
        ".ignore".source = ./ignore;
        ".local/bin/git-clone-bare".source = ./scripts/bin/git-clone-bare;
        ".local/bin/nix-view-build".source = ./scripts/bin/nix-view-build;
        ".local/bin/nixos-switch".source = ./scripts/bin/nixos-switch;
        ".local/bin/nvim-difftool".source = ./scripts/bin/nvim-difftool;
        ".config/dotfiles/rc.sh".source = ./scripts/rc.sh;
        ".config/dotfiles/aliases.sh".source = ./scripts/aliases.sh;
        ".config/dotfiles/s3-copy.sh".source = ./scripts/s3-copy.sh;
      };
    };
}
