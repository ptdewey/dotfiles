local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

-- tex
ls.add_snippets("tex", {
    -- begin/end block
    s("beg", fmt("\\begin{{{}}}\n\n\\end{{{}}}", { i(1), rep(1) })),

    -- section
    s("sec", fmt("\\section{{{}}}\n", i(1))),

    -- subsection
    s("sub", fmt("\\subsection{{{}}}\n", i(1))),

    -- fraction
    s("frac",
        fmt("\\frac{{{}}}{{{}}}", {
            i(1, "numerator"),
            i(2, "denominator")
        })
    ),

    -- sum
    s("sum",
        fmt("\\sum_{{{}}}^{{{}}} {}", {
            i(1, "lower"),
            i(2, "upper"),
            i(3, "expression")
        })
    ),
})
