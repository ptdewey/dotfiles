-- Mouse follows focus
hs.loadSpoon("EmmyLua")
hs.loadSpoon("MouseFollowsFocus")
spoon.MouseFollowsFocus:start()

-- Hot reloading of config
hs.hotkey.bind({ "cmd", "ctrl" }, "R", function()
    hs.reload()
    hs.alert.show("Config loaded")
end)



-- local function focusAppByTitle(windowTitle)
--     local allWindows = hs.window.allWindows()
--     for _, win in ipairs(allWindows) do
--         if win:title():find(targetWindowName) then
--             win:focus()
--             return
--         end
--     end
--     hs.alert.show("Window not found: " .. targetWindowName)
-- end


--
-- Navigation
--
local function focusApp(appName)
    local app = hs.application.get(appName)
    if app then
        app:activate()
    else
        hs.alert.show("App not running: " .. appName)
        -- TODO: open application if not running (optionally with param?)
    end
end

-- Focus hotkeys
hs.hotkey.bind({ "ctrl" }, "T", function() focusApp("WezTerm") end)
hs.hotkey.bind({ "ctrl" }, "B", function() focusApp("Zen") end) -- NOTE: switch this key to open zen
hs.hotkey.bind({ "ctrl" }, "X", function() focusApp("Slack") end)
hs.hotkey.bind({ "ctrl", "cmd" }, "e", function() focusApp("Outlook") end)
hs.hotkey.bind({ "ctrl", "cmd" }, "d", function() focusApp("Finder") end)

-- "Workspace" navigation
-- TODO:
-- - number hotkeys that match to windows at same locations as I use with niri
