local wezterm = require("wezterm")

local M = {}

-- set windows specific settings
function M.apply_to_config(config)
    local wsl_domains = wezterm.default_wsl_domains()
    for _, dom in ipairs(wsl_domains) do
        dom.default_cwd = "~"
        -- dom.default_prog = { "cd ~" }
    end

    config.default_domain = "WSL:Ubuntu"

    -- TODO: might need to merge this with keys table
    config.keys = {
        {
            key = "p",
            mods = "CTRL|SHIFT",
            action = wezterm.action.SpawnCommandInNewTab({
                args = { "powershell.exe" },
                domain = { DomainName = "local" },
            }),
        },
    }
end

return M
