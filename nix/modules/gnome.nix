# Gnome setup
{ pkgs, ... }:
{
  services = {
    # Enable/disable X11
    xserver.enable = true;

    # Enable gnome
    desktopManager.gnome.enable = true;

    # Enable gdm
    displayManager.gdm.enable = true;
  };

  # Install packages and extensions
  environment.systemPackages = with pkgs; [
    gnome-tweaks

    # Extensions
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.appindicator
    gnomeExtensions.disable-workspace-switch-animation-for-gnome-40

    # GTK theming
    yaru-theme
    bibata-cursors
  ];

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            "cursor-theme" = "Bibata-Modern-Classic";
            "font-name" = "IosevkaPatrick Nerd Font 16";
            "document-font-name" = "IosevkaPatrick Nerd Font 11";
            "monospace-font-name" = "IosevkaPatrick Nerd Font 10";
            "color-scheme" = "prefer-dark";
            "clock-format" = "12h";
            "gtk-theme" = "Yaru-sage-dark";
            "icon-theme" = "Yaru-sage-dark";
            "enable-hot-corners" = false;
          };
          "org/gnome/desktop/peripherals/mouse" = {
            "accel-profile" = "flat";
            "natural-scroll" = false;
            "speed" = -0.19650655021834063;
          };
          "org/gnome/desktop/sound" = {
            event-sounds = false;
          };
          "org/gnome/desktop/wm/keybindings" = {
            close = [ "<Shift><Super>q" ];
            move-to-workspace-1 = [ "<Shift><Super>1" ];
            move-to-workspace-2 = [ "<Shift><Super>2" ];
            move-to-workspace-3 = [ "<Shift><Super>3" ];
            move-to-workspace-4 = [ "<Shift><Super>4" ];
            switch-input-source = "@as []";
            switch-input-source-backward = "@as []";
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
          };
          "org/gnome/mutter" = {
            "dynamic-workspaces" = true;
          };
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            ];
            help = "@as []";
            magnifier = "@as []";
            magnifier-zoom-in = "@as []";
            magnifier-zoom-out = "@as []";
            screenreader = "@as []";
            screensaver = [ "<Super>Escape" ];
            www = [ "<Super>b" ];
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>t";
            command = "wezterm";
            name = "Wezterm";
          };
          "org/gnome/shell/app-switcher" = {
            current-workspace-only = false;
          };
          "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
            "blur" = true;
            "brightness" = "0.59999999999999998";
            "override-background" = true;
            "pipeline" = "pipeline_default";
            "sigma" = "30";
            "static-blur" = true;
            "style-dash-to-dock" = "0";
            "unblur-in-overview" = false;
          };
          "org/gnome/shell/extensions/dash-to-dock" = {
            "always-center-icons" = true;
            "application-counter-overrides-notifications" = true;
            "apply-custom-theme" = true;
            "background-opacity" = 0.8;
            "custom-background-color" = false;
            "custom-theme-shrink" = true;
            "dance-urgent-applications" = false;
            "dash-max-icon-size" = "52";
            "dock-fixed" = true;
            "dock-position" = "'LEFT'";
            "extend-height" = true;
            "height-fraction" = 1.0;
            "hide-tooltip" = false;
            "hot-keys" = false;
            "icon-size-fixed" = false;
            "isolate-monitors" = false;
            "middle-click-action" = "'launch'";
            "multi-monitor" = false;
            "preferred-monitor" = "-2";
            "preferred-monitor-by-connector" = "'DP-2'";
            "preview-size-scale" = 0.2;
            "running-indicator-style" = "'DEFAULT'";
            "scroll-action" = "'switch-workspace'";
            "shift-click-action" = "'minimize'";
            "shift-middle-click-action" = "'launch'";
            "show-apps-always-in-the-edge" = true;
            "show-apps-at-top" = false;
            "show-favorites" = true;
            "show-icons-emblems" = true;
            "show-icons-notifications-counter" = false;
            "show-mounts" = false;
            "show-mounts-only-mounted" = false;
            "show-trash" = false;
            "show-windows-preview" = true;
            "workspace-agnostic-urgent-windows" = false;
          };
          "org/gnome/shell/extensions/user-theme" = {
            name = "Yaru-sage-dark";
          };
          "org/gnome/shell/keybindings" = {
            focus-active-notification = "@as []";
            screenshot = "@as []";
            screenshot-window = "@as []";
            show-screen-recording-ui = "@as []";
            show-screenshot-ui = [ "<Shift><Super>s" ];
            switch-to-application-1 = "@as []";
            switch-to-application-2 = "@as []";
            switch-to-application-3 = "@as []";
            switch-to-application-4 = "@as []";
            toggle-overview = "@as []";
          };
          "org/gtk/settings/file-chooser" = {
            clock-format = "12h";
          };
        };
      }
    ];
  };

  # Udev service for systray
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # exclude default gnome packages
  environment.gnome.excludePackages = with pkgs; [
    orca
    geary
    gnome-tour
    gnome-user-docs
    baobab
    epiphany
    gnome-text-editor
    gnome-calculator
    gnome-maps
    gnome-logs
    gnome-music
    gnome-weather
    gnome-connections
    simple-scan
    totem
    yelp
    gnome-software
  ];
}
