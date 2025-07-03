local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

ls.add_snippets("tex", {
    s("beg", fmt("\\begin{{{}}}\n\t{}\n\\end{{{}}}", { i(1), i(0), rep(1) })),
    s("sec", fmt("\\section{{{}}}\n{}", { i(1), i(0) })),
    s("sub", fmt("\\subsection{{{}}}\n{}", { i(1), i(0) })),
    s(
        "frac",
        fmt("\\frac{{{}}}{{{}}}{}", {
            i(1, "numerator"),
            i(2, "denominator"),
            i(0),
        })
    ),
    s(
        "sum",
        fmt("\\sum_{{{}}}^{{{}}} {}", {
            i(1, "lower"),
            i(2, "upper"),
            i(3, "expression"),
        })
    ),
    s(
        "list",
        fmt(
            "\\begin{{itemize}}\n\t\\item {}\n\\end{{itemize}}\n{}",
            { i(1), i(0) }
        )
    ),
    s("bf", fmt("\\textbf{{{}}}{}", { i(1), i(0) })),
    s("it", fmt("\\textit{{{}}}{}", { i(1), i(0) })),
})
