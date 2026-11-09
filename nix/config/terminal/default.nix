_: {
  flake.homeModules.patrick =
    { config, ... }:
    {
      home.file = {
        ".tmux.conf".source = ./tmux.conf;
        ".local/bin/tmux-sessionizer".source = ./scripts/tmux-sessionizer.sh;
      };

      xdg.configFile = {
        "ohmyposh".source = ./ohmyposh;
        "wezterm".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix/config/terminal/wezterm";
      };
    };
}
