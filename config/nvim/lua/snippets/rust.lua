local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

ls.add_snippets("rust", {
    s("der", fmt("#[derive({})]{}", { i(1), i(0) })),
    s("bevy", fmt("use bevy::prelude::*;\n{}", { i(0) })),

    s(
        "test",
        fmt(
            "#[test]\nfn test_{}() {{\n\tlet out = {}({});\n}}{}",
            { i(1), rep(1), i(2), i(0) }
        )
    ),

    s("cfg", fmt("#[cfg(test)]\nmod test {{\n\t{}\n}}{}", { i(1), i(0) })),

    -- TODO: decision node for return type
    s("fn", fmt("fn {}({}) {{\n\t{}\n}}{}", { i(1), i(2), i(3), i(0) })),
})
