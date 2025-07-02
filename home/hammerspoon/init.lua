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
local function focusApp(appName, opts)
    local app = hs.application.get(appName)
    if app then
        app:activate()
    else
        if opts and opts.open then
            hs.application.open(appName)
        else
            hs.alert.show("App not running: " .. appName)
        end
        -- TODO: open application if not running (optionally with param?)
    end
end

-- Focus hotkeys
hs.hotkey.bind({ "ctrl" }, "t", function() focusApp("WezTerm", { open = true }) end)
hs.hotkey.bind({ "ctrl" }, "b", function() focusApp("Zen", { open = true }) end)
hs.hotkey.bind({ "ctrl" }, "s", function() focusApp("Slack", { open = true }) end)
hs.hotkey.bind({ "ctrl", "shift" }, "x", function() focusApp("Slack", { open = true }) end)
hs.hotkey.bind({ "ctrl", "cmd" }, "x", function() focusApp("Slack", { open = true }) end)
hs.hotkey.bind({ "ctrl", "cmd" }, "e", function() focusApp("Outlook", { open = true }) end)
hs.hotkey.bind({ "ctrl", "cmd" }, "d", function() focusApp("Finder", { open = true }) end)

-- "Workspace" navigation
-- TODO:
-- - number hotkeys that match to windows at same locations as I use with niri
