{ ... }:
{
  home.file.".tmux.conf".source = ../../../dotfiles/home/tmux.conf;

  xdg.configFile = {
    "ohmyposh".source = ../../../dotfiles/xdg/ohmyposh;
    "wezterm".source = ../../../dotfiles/xdg/wezterm;
  };
}
