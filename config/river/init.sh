#!/bin/sh

# NOTE: this seems to be important?
# dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river

# Mod key
riverctl map normal Super Return spawn wezterm
riverctl map normal Super D spawn fuzzel
riverctl map normal Super Q close
riverctl map normal Super+Shift E exit

# Tags (workspaces)
for i in $(seq 1 9); do
    tags=$((1 << ($i - 1)))
    riverctl map normal Super $i set-focused-tags $tags
    riverctl map normal Super+Shift $i set-view-tags $tags
done

# Layout
riverctl default-layout rivertile
riverctl attach-mode bottom
rivertile -view-padding 4 -outer-padding 4 &

# Autostart
waybar &
# mako &
