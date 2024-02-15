local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

-- CUDA snippets
ls.add_snippets("cuda", {
    s("global", fmt("__global__ void {}(int N) {{\n\t" ..
        "int n = threadIdx.x + blockIdx.x * blockDim.x;\n}}",
        { i(1) })),
})

