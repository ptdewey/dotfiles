local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

-- lua snippets
ls.add_snippets("lua", {
    -- function
    s("func", fmt("function {}({})\n\t{}\nend", {i(1), i(2), i(0)})),

    -- if
    s("if", fmt("if {} then\n\t{}\nend", {i(1), i(0)})),

    -- for loop (numeric)
    s("for", fmt("for {} = {}, {} do\n\t{}\nend",
        { i(1, "i"), i(2, "1"), i(3, "n"), i(0) })),

    -- print
    s("pr", fmt('print("{}")', {i(1)})),

    -- require
    s("req", fmt("local {} = require('{}')",
        { i(1), rep(1) })),

    -- add new snippet block
    s("add_snippet", fmt("ls.add_snippets(\"{}\", {{\n\t{}\n}})",
        { i(1), i(0) })),

    -- add new snippet (requires outer block)
    s("snip", fmt("s(\"{}\", fmt(\"{}\", {{ i(1) }})),",
        { i(1), i(2) })),
})

