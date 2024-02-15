local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

-- rmd snippets
ls.add_snippets("rmd", {
    s("``", fmt("```{{r}}\n{}\n```", i(1))),
})
