{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nix-prefetch-git
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
    fastfetch
    htop
    tmux
    lsd
    plantuml
    zathura
    vhs
    feh
    oh-my-posh
    neovim
    xclip
    typst
    tree-sitter
    stylua
    luajitPackages.jsregexp
    luajitPackages.luacheck
    go
    glow
    prettierd
    openssl
    brightnessctl
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
