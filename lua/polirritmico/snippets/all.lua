-- Snippets para todos los tipos de archivo
local ls = require("luasnip")
local s, t, i, c, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local p = require("luasnip.extras").partial
local rep = require("luasnip.extras").rep

-- Avoid multiple versions of the same snippet on reload
local reload_key = { key = "my_all_snippets" }

ls.add_snippets("all", {
    s({ trig = "datecurrent", name = "Current date",
        dscr = "Insert the current date in various formats"
        },
        c(1, {
            p(os.date, "%Y-%m-%d"),
            p(os.date, "%d-%m-%Y"),
            p(os.date, "%H:%M"),
            p(os.date, "%Y-%m-%d %H:%M"),
            p(os.date, "%d-%m-%Y %H:%M"),
        })
    ),

    s(
        {trig = "license", name = "License Layout", dscr = "Template with various licenses."},
        fmt([[
            # Copyright (C) {} {}
            #
            # This program is part of {} and is released under
            # the {}


            ]], {
        f(function() return os.date "%Y" end),
        c(1, {
            t("Eduardo Bray (ejbray@uc.cl)"),
            t("Estudios 6/8 (bakumapu@gmail.com)"),
            i(1),
        }),
        i(2, "Project-Name"),
        c(3, {
            t("GPLv2 License: https://www.gnu.org/licenses/old-licenses/gpl-2.0.html"),
            t("GPLv3 License: https://www.gnu.org/licenses/gpl-3.0.html"),
            t("Apache-2.0 License: https://www.apache.org/licenses/LICENSE-2.0"),
            t("MIT License: https://mit-license.org/"),
            i(1)
        })
    })),

    s(
        {trig = "header", name = "Framed header",
        dscr = "A framed header that wraps around the content."}, fmt([[
        ---{}---
        -- {} --
        ---{}---

        {}]], {
        f(function(args) return string.rep("-", string.len(args[1][1])) end, {1}),
        i(1),
        f(function(args) return string.rep("-", string.len(args[1][1])) end, {1}),
        i(0)
    })),
}, reload_key)
