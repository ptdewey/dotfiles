_: {
  flake.homeModules.patrick =
    { ... }:
    {
      home.file = {
        ".tmux.conf".source = ./tmux.conf;
        ".local/bin/tmux-pick-session".source = ./scripts/tmux-pick-session;
        ".local/bin/tmux-sessionizer".source = ./scripts/tmux-sessionizer.sh;
        ".local/bin/tmux-todoizer".source = ./scripts/tmux-todoizer.sh;
        ".local/bin/tmux-spotify-queuer".source = ./scripts/tmux-spotify-queuer.sh;
      };

      xdg.configFile = {
        "ohmyposh".source = ./ohmyposh;
        "wezterm".source = ./wezterm;
      };
    };
}
