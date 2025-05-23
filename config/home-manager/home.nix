{ pkgs, ... }:
{
  # Enable home-manager and channel version
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  # Set username and home directory
  home.username = "patrick";
  home.homeDirectory = "/home/patrick";

  # Imports
  imports = [ ];

  # Direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Install nix packages into environment
  home.packages = with pkgs; [
    ## nix extras
    nix-prefetch-git

    ## misc command line utils
    csvlens
    fd
    foliate
    fx
    fzf
    ripgrep
    tokei
    shellcheck-minimal
    jq
    pandoc
    neofetch
    htop
    tmux
    lsd
    plantuml
    zathura
    vhs
    feh
    oh-my-posh

    ## neovim stuff
    neovim
    xclip
    typst
    tree-sitter

    ## languages and related utils
    stylua
    luajitPackages.jsregexp
    luajitPackages.luacheck
    go
    glow
    # nodejs
    prettierd
    openssl
    # rustup
    brightnessctl

    ## window manager config
    # dunst

    ## other gui applications
    # discord
    # spotify
    # yt-dlp
  ];

  # Manage environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # # GTK theming
  # gtk = {
  #   enable = true;
  #   font = {
  #     name = "IosevkaPatrick Nerd Font";
  #     size = 16;
  #   };
  #   cursorTheme = {
  #     package = pkgs.bibata-cursors;
  #     name = "Bibata-Modern-Classic";
  #   };
  # };

  # Manage dotfiles
  home.file = {
    ".local/share/icons/bibata".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
  };
}
