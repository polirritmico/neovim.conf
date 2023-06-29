-- Lua Snippets
local ls = require("luasnip")
local s, t, i, c, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("lua", {
    s(
        {trig = "require", name = "Require snippet",
        dscr = "Set the variable name to the last require."}, fmt([[
        local {} = require("{}"){}]],
        {f(function(import_name)
            local parts = vim.split(import_name[1][1], ".", true)
            return parts[#parts] or ""
        end, { 1 }),
        i(1), i(0)
    })),

    --s({trig = "snippet", dscr = "Meta-snippet to make snippets."}, fmt([=[
    --    s(
    --        {{trig = "{}", name = "{}", dscr = "{}"}}, fmt([[
    --        {}
    --        ]], {{
    --        {}
    --    }})),]=], {
    --    i(1, "trigger"),
    --    i(2, "Name"),
    --    i(3, "Description"),
    --    i(4),
    --    i(5),
    --})),

    s({trig = "snippet", dscr = "Meta-snippet to make snippets."},
    c(1, {
        fmt([=[
            s("{}", fmt({}, {{{}}})),]=], {
            i(1, "trigger"),
            i(2, "\"snippet\""),
            i(3)
        }),
        fmt([=[
            s(
                {{trig = "{}", name = "{}", dscr = "{}"}}, fmt([[
                {}
                ]], {{
                {}
            }})),]=], {
            i(1, "trigger"),
            i(2, "Name"),
            i(3, "Description"),
            i(4),
            i(5)
        }),
    })),
})
