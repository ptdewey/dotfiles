local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

-- Go snipets
ls.add_snippets("go", {
    -- function
    s("func", fmt("func {}({}) {} {{\n\t{}\n}}", { i(1), i(2), i(3), i(4) })),

    -- error check
    s("if err", fmt("if err := nil {{\n\tfmt.Println(\"Error {}:\", err)\n\treturn\n}}",
        { i(1, "") }))
})

