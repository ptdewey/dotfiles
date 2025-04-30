-- TODO: load based on filetypes instead of all at once (autocmd)
local function load_snippets()
    local snippet_files = {
        "all",
        "lua",
        "tex",
        "r",
        "rmd",
        "go",
        "c",
        "cuda",
        "markdown",
        "rust",
        "sh",
    }

    for _, file in ipairs(snippet_files) do
        require("snippets." .. file)
    end
end

load_snippets()
