{ pkgs, ... }:
{
  home.file = {
    ".aerospace.toml".source = ../../../dotfiles/home/aerospace.toml;
    ".bashrc".source = ../../../dotfiles/home/bashrc;
    ".claude/CLAUDE.md".source = ../../../dotfiles/home/claude/CLAUDE.md;
    ".claude/settings.json".source = ../../../dotfiles/home/claude/settings.json;
    ".hammerspoon/.luarc.json".source = ../../../dotfiles/home/hammerspoon/.luarc.json;
    ".hammerspoon/Spoons/EmmyLua.spoon/docs.json".source =
      ../../../dotfiles/home/hammerspoon/Spoons/EmmyLua.spoon/docs.json;
    ".hammerspoon/Spoons/EmmyLua.spoon/init.lua".source =
      ../../../dotfiles/home/hammerspoon/Spoons/EmmyLua.spoon/init.lua;
    ".hammerspoon/Spoons/MouseFollowsFocus.spoon/docs.json".source =
      ../../../dotfiles/home/hammerspoon/Spoons/MouseFollowsFocus.spoon/docs.json;
    ".hammerspoon/init.lua".source = ../../../dotfiles/home/hammerspoon/init.lua;
    ".hammerspoon/Spoons/MouseFollowsFocus.spoon/init.lua".source =
      ../../../dotfiles/home/hammerspoon/Spoons/MouseFollowsFocus.spoon/init.lua;
    ".ignore".source = ../../../dotfiles/home/ignore;
    ".matcha.toml".source = ../../../dotfiles/home/matcha.toml;
    ".stylua.toml".source = ../../../dotfiles/home/stylua.toml;
    ".tmux.conf".source = ../../../dotfiles/home/tmux.conf;
    ".vimrc".source = ../../../dotfiles/home/vimrc;
    ".zshrc".source = ../../../dotfiles/home/zshrc;

    ".local/share/icons/bibata".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";

    ".local/share/fonts/custom/MaterialIcons/MaterialIcons-Regular.ttf".source =
      ../../../fonts/MaterialIcons/MaterialIcons-Regular.ttf;
    ".local/share/fonts/custom/MaterialIcons/MaterialIconsOutlined-Regular.otf".source =
      ../../../fonts/MaterialIcons/MaterialIconsOutlined-Regular.otf;
    ".local/share/fonts/custom/MaterialIcons/MaterialIconsRound-Regular.otf".source =
      ../../../fonts/MaterialIcons/MaterialIconsRound-Regular.otf;
    ".local/share/fonts/custom/MaterialIcons/MaterialIconsSharp-Regular.otf".source =
      ../../../fonts/MaterialIcons/MaterialIconsSharp-Regular.otf;
    ".local/share/fonts/custom/MaterialIcons/MaterialIconsTwoTone-Regular.otf".source =
      ../../../fonts/MaterialIcons/MaterialIconsTwoTone-Regular.otf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-italic.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-italic.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-light.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-light.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-lightitalic.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-lightitalic.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-lightoblique.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-lightoblique.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-medium.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-medium.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-mediumitalic.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-mediumitalic.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-mediumoblique.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-mediumoblique.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-oblique.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-oblique.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-regular.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-regular.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-semibold.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-semibold.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-semibolditalic.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-semibolditalic.ttf;
    ".local/share/fonts/custom/patricks-iosevka/patricks-iosevka-semiboldoblique.ttf".source =
      ../../../fonts/patricks-iosevka/patricks-iosevka-semiboldoblique.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaNerdFont-Regular.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaNerdFont-Regular.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-Italic.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-Italic.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-Light.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-Light.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-LightItalic.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-LightItalic.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-LightOblique.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-LightOblique.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-Medium.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-Medium.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-MediumItalic.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-MediumItalic.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-MediumOblique.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-MediumOblique.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-Oblique.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-Oblique.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-Regular.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-Regular.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-SemiBold.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-SemiBold.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-SemiBoldItalic.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-SemiBoldItalic.ttf;
    ".local/share/fonts/custom/patricks-iosevka-patched/IosevkaPatrickNerdFont-SemiBoldOblique.ttf".source =
      ../../../fonts/patricks-iosevka-patched/IosevkaPatrickNerdFont-SemiBoldOblique.ttf;
  };

  xdg.configFile = {
    "blueprinter/blueprinter.toml".source = ../../../dotfiles/xdg/blueprinter/blueprinter.toml;
    "harper-ls/dictionary.txt".source = ../../../dotfiles/xdg/harper-ls/dictionary.txt;
    "helix/config.toml".source = ../../../dotfiles/xdg/helix/config.toml;
    "helix/languages.toml".source = ../../../dotfiles/xdg/helix/languages.toml;
    "herdr/.plugins.lock".source = ../../../dotfiles/xdg/herdr/.plugins.lock;
    "herdr/config.toml".source = ../../../dotfiles/xdg/herdr/config.toml;
    "jj/config.toml".source = ../../../dotfiles/xdg/jj/config.toml;
    "niri/config.kdl".source = ../../../dotfiles/xdg/niri/config.kdl;
    "nix/nix.conf".source = ../../../dotfiles/xdg/nix/nix.conf;
    "nixpkgs/config.nix".source = ../../../dotfiles/xdg/nixpkgs/config.nix;
    "noctalia/colors.json".source = ../../../dotfiles/xdg/noctalia/colors.json;
    "noctalia/settings.json".source = ../../../dotfiles/xdg/noctalia/settings.json;
    "ohmyposh/omp.toml".source = ../../../dotfiles/xdg/ohmyposh/omp.toml;
    "sway/config".source = ../../../dotfiles/xdg/sway/config;
    "waybar/config.jsonc".source = ../../../dotfiles/xdg/waybar/config.jsonc;
    "waybar/style.css".source = ../../../dotfiles/xdg/waybar/style.css;
    "wezterm/colors/darkearth.toml".source = ../../../dotfiles/xdg/wezterm/colors/darkearth.toml;
    "wezterm/colors/lightearth.toml".source = ../../../dotfiles/xdg/wezterm/colors/lightearth.toml;
    "wezterm/colors/oxocarbon-dark.toml".source =
      ../../../dotfiles/xdg/wezterm/colors/oxocarbon-dark.toml;
    "wezterm/wezterm.lua".source = ../../../dotfiles/xdg/wezterm/wezterm.lua;
    "wezterm/windows.lua".source = ../../../dotfiles/xdg/wezterm/windows.lua;
    "zathura/zathurarc".source = ../../../dotfiles/xdg/zathura/zathurarc;
  };
}
