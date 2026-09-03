{ ... }:
{
  home.file = {
    ".bashrc".source = ../../../dotfiles/home/bashrc;
    ".zshrc".source = ../../../dotfiles/home/zshrc;
    ".ignore".source = ../../../dotfiles/home/ignore;
    ".matcha.toml".source = ../../../dotfiles/home/matcha.toml;
  };
}
