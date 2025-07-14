local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

ls.add_snippets("lua", {
    s("req", fmt('local {} = require("{}")', { i(1), rep(1) })),
    s("snip", fmt('s("{}", fmt("{}", {{ i(1) }})),', { i(1), i(2) })),
})
