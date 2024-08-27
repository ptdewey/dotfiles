local awful = require("awful")

awful.spawn("setxkbmap -option caps:escape")

terminal = user.terminal
editor = user.editor
editor_cmd = terminal .. " -e " .. editor
