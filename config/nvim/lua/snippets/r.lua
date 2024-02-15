local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

-- r snippets
ls.add_snippets("r", {
    s("func", fmt("function() {{\n\t{}\n}}", i(0))),
})
