local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

local function split_commentstring()
    local commentstring = vim.bo.commentstring
    if not commentstring or commentstring == "" then
        return "", ""
    end
    local prefix, suffix = commentstring:match("^(.-)%%s(.-)$")

    if not prefix:match("%s$") then
        prefix = prefix .. " "
    end

    if suffix == nil then
        suffix = ""
    end

    return prefix, suffix
end

local prefix, suffix = split_commentstring()

ls.add_snippets("all", {
    -- current date
    s("date", fmt("{}{}", { os.date("%D"), i(0) })),

    -- todo comment
    --  TODO: check if comment string is already preceding on current line?
    s("todo", fmt("{}TODO: {}{}{}", { prefix, i(1), suffix, i(0) })),
})
