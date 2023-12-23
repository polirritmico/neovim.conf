-- Lua Snippets
local ls = require("luasnip")
local s, t, i, c, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Avoid multiple versions of the same snippet on reload
local reload_key = { key = "my_lua_snippets" }

ls.add_snippets("lua", {
    s(
        {trig = "require", name = "Require snippet",
        dscr = "Set the variable name to the last require."}, fmt([[
        local {} = require("{}"){}]],
        {f(function(import_name)
            -- local parts = vim.split(import_name[1][1], ".", true)
            local parts = vim.split(import_name[1][1], ".", { plain = true })
            return parts[#parts] or ""
        end, { 1 }),
        i(1), i(0)
    })),

    s({trig = "snippet", dscr = "Meta-snippet to make snippets."},
        fmt("{}", {
        c(1, {
            fmt([=[
                s("{}", fmt({}, {{{}}})),]=], {
                i(1),
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
                i(1),
                i(2, "Name"),
                i(3, "Description"),
                i(4),
                i(5)
            }),
        })
    })),

    s(
        {trig = "mapping", name = "Add keymap",
        dscr = "Layout for adding custom keymaps to Neovim."}, fmta([[
	    vim.keymap.set(<mode>, "<key>", <command>, {<options>})
        ]], {
            mode = c(1, {
                t('{"n"}'),
                t('{"n", "v"}'),
                t('{"v"}'),
                t('{"i"}'),
                fmt('"{}"', i(1)),
            }),
        key = c(2, {fmt("<leader>{}", i(1)), i(1)}),
        command = c(3, {fmt([[":{}<CR>"]], i(1, "command")), i(1, "vim.command")}),
        options = t("silent = true"),
    })),

    s(
        {trig = "---", name = "Horizontal line",
        dscr = "A horizontal separation line (79 characters)."},
        t("-------------------------------------------------------------------------------")
    ),

}, reload_key)
