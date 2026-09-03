{ ... }:
{
  home.file = {
    ".aerospace.toml".source = ../../../dotfiles/home/aerospace.toml;
    ".claude/CLAUDE.md".source = ../../../dotfiles/home/claude/CLAUDE.md;
    ".claude/settings.json".source = ../../../dotfiles/home/claude/settings.json;
    ".hammerspoon".source = ../../../dotfiles/home/hammerspoon;
  };

  xdg.configFile = {
    "niri".source = ../../../dotfiles/xdg/niri;
    "noctalia".source = ../../../dotfiles/xdg/noctalia;
    "sway".source = ../../../dotfiles/xdg/sway;
    "waybar".source = ../../../dotfiles/xdg/waybar;
  };
}
