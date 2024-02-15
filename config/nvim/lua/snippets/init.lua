-- ~/.config/nvim/lua/snippets/init.lua
local function load_snippets()
    local snippet_files = {
        "lua",
        "tex",
        "r",
        "rmd",
        "go"
    }

    for _, file in ipairs(snippet_files) do
        require('snippets.' .. file)
    end
end

load_snippets()
