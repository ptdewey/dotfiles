local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

-- C snippets
ls.add_snippets("c", {
    -- for loop
    s("for", fmt("for (int {} = 0; {} < {}, {}++) {{\n}}",
        { i(1, "i"), rep(1), i(2, "N"), rep(1) })),

    -- if statement
    s("if", fmt("({}) {{\n}}", { i(1) })),
})
