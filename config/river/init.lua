local function rc(...)
  local args = {...}
  table.insert(args, 1, "riverctl")
  return os.execute(table.concat(args, " "))
end
rc("map", "normal", "Super", "T", "spawn", "wezterm")
rc("map", "normal", "Super", "B", "spawn", "zen-beta")
rc("map", "normal", "Super", "D", "spawn", "fuzzel")
rc("map", "normal", "Super", "Q", "close")
rc("map", "normal", "Super+Shift", "E", "exit")
rc("map", "normal", "Super+Shift", "F", "toggle-fullscreen")
rc("map", "normal", "Super+Shift", "R", "spawn", "~/.config/river/init")
rc("map", "normal", "Super", "H", "focus-view", "left")
rc("map", "normal", "Super", "J", "focus-view", "down")
rc("map", "normal", "Super", "K", "focus-view", "up")
rc("map", "normal", "Super", "L", "focus-view", "right")
rc("map", "normal", "Super+Shift", "H", "swap", "left")
rc("map", "normal", "Super+Shift", "J", "swap", "down")
rc("map", "normal", "Super+Shift", "K", "swap", "up")
rc("map", "normal", "Super+Shift", "L", "swap", "right")
rc("keyboard-repeat-rate", 50)
rc("keyboard-repeat-delay", 300)
rc("keyboard-layout", "-options", "caps:escape", "us")
rc("xcursor-theme", "Bibata-Modern-Classic", "24")
for i = 1, 9 do
  local tags
  do
    local bit_2_auto = require("bit")
    tags = tostring(bit_2_auto.lshift(1, (i - 1)))
  end
  rc("map", "normal", "Super", tostring(i), "set-focused-tags", tags)
  rc("map", "normal", "Super+Shift", tostring(i), "set-view-tags", tags)
end
local function assign_tag(app_id, tag_num)
  local function _1_()
    local bit_2_auto = require("bit")
    return tostring(bit_2_auto.lshift(1, (tag_num - 1)))
  end
  return rc("rule-add", "-app-id", app_id, "tags", _1_())
end
assign_tag("zen-beta", 2)
rc("default-layout", "rivertile")
rc("attach-mode", "bottom")
os.execute("rivertile -view-padding 2 -outer-padding 2 &")
return os.execute("waybar &")