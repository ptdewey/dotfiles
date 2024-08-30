local awful = require("awful")

awful.spawn("setxkbmap -option caps:escape")
awful.spawn("xset r rate 500 40")

terminal = user.terminal
editor = user.editor
editor_cmd = terminal .. " -e " .. editor
