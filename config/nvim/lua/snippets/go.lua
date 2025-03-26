local ls = require("luasnip")
local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.sn
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local fmt = require("luasnip.extras.fmt").fmt

local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")

local get_node_text = vim.treesitter.get_node_text

-- Define transforms from function return type to return value
local transforms = {
    int = function(_, _)
        return t("0")
    end,

    bool = function(_, _)
        return t("false")
    end,

    string = function(_, _)
        return t([[""]])
    end,

    error = function(_, _)
        return t("err")
    end,

    -- Types with a "*" mean they are pointers, so return nil
    [function(text)
        return not string.find(text, "*", 1, true)
            and string.upper(string.sub(text, 1, 1))
                == string.sub(text, 1, 1)
    end] = function(_, _)
        return t("nil")
    end,

    -- Struct types, non-pointer case
    [function(text)
        return string.find(text, "*", 1, true)
    end] = function(_, _)
        return t("nil")
    end,
}

local transform = function(text, info)
    local condition_matches = function(condition, ...)
        if type(condition) == "string" then
            return condition == text
        else
            return condition(...)
        end
    end

    for condition, result in pairs(transforms) do
        if condition_matches(condition, text, info) then
            return result(text, info)
        end
    end

    return t(text)
end

local handlers = {
    parameter_list = function(node, info)
        local result = {}

        local count = node:named_child_count()
        for idx = 0, count - 1 do
            local matching_node = node:named_child(idx)
            local type_node = matching_node:field("type")[1]
            table.insert(result, transform(get_node_text(type_node, 0), info))
            if idx ~= count - 1 then
                table.insert(result, t({ ", " }))
            end
        end

        return result
    end,

    type_identifier = function(node, info)
        local text = get_node_text(node, 0)
        return { transform(text, info) }
    end,
}

local function_node_types = {
    function_declaration = true,
    method_declaration = true,
    func_literal = true,
}

local function go_result_type(info)
    local cursor_node = ts_utils.get_node_at_cursor()
    local scope = ts_locals.get_scope_tree(cursor_node, 0)

    local function_node
    for _, v in ipairs(scope) do
        if function_node_types[v:type()] then
            function_node = v
            break
        end
    end

    if not function_node then
        print("Not inside of a function")
        return t("")
    end

    local query = vim.treesitter.query.parse(
        "go",
        [[
            [
                (method_declaration result: (_) @id)
                (function_declaration result: (_) @id)
                (func_literal result: (_) @id)
            ]
        ]]
    )
    for _, node in query:iter_captures(function_node, 0) do
        if handlers[node:type()] then
            return handlers[node:type()](node, info)
        end
    end

    -- no return type case
    return { t("") }
end

local go_ret_vals = function(args)
    return sn(
        nil,
        go_result_type({
            index = 0,
            err_name = args[1][1],
        })
    )
end

-- Go snipets
ls.add_snippets("go", {
    -- function
    s("func", fmt("func {}({}) {}{{\n\t{}\n}}", { i(1), i(2), i(3), i(4) })),

    -- print statement
    s("print", fmt('fmt.Println("{}")', { i(1) })),

    -- struct typedef
    s("typ", fmt("type {} struct {{\n\t{}\n}}{}", { i(1), i(2), i(0) })),

    -- append
    s("app", fmt("{} = append({}, {}){}", { i(1), rep(1), i(2), i(0) })),

    -- error check
    s(
        "err",
        fmt(
            "if {} != nil {{\n\treturn {}\n}}\n{}",
            { i(1, "err"), d(2, go_ret_vals, { 1 }), i(0) }
        )
    ),

    -- s(
    --     "err",
    --     fmt(
    --         "{} := {}\nif {} != nil {{\n\treturn {}\n}}\n{}",
    --         { i(2, "err"), i(1), rep(2), d(3, go_ret_vals, { 2 }), i(0) }
    --     )
    -- ),

    s("lerr", fmt("log.Println(err){}", { i(0) })),

    s(
        "efi",
        fmta(
            [[
                <val>, <err> := <f>(<args>)
                if <err_same> != nil {
                    return <result>
                }
                <finish>
            ]],
            {
                val = i(1),
                err = i(2, "err"),
                f = i(3),
                args = i(4),
                err_same = rep(2),
                result = d(5, go_ret_vals, { 2 }),
                finish = i(0),
            }
        )
    ),
})
