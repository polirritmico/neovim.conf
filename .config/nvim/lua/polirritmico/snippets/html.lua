-- HTML Snippets
local ls = require("luasnip")
local s, t, i, c, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

ls.add_snippets("html", {
    -- Headers
    s(
        {trig = "h1", name = "Header 1", dscr = "Level 1 header"}, fmt([[
        <h{}>{}</h1>{}
        ]], {
        c(1, {t("1"), fmt([[1 class="{}"]], i(1, "class"), {dedent=false}), t("1")}),
        i(2, "Title"),
        i(0)
    })),

    s(
        {trig = "h2", name = "Header 2", dscr = "Level 2 header"}, fmt([[
        <h{}>{}</h2>{}
        ]], {
        c(1, {t("2"), fmt([[2 class="{}"]], i(1, "class"), {dedent=false}), t("2")}),
        i(2, "Title"),
        i(0)
    })),

    s(
        {trig = "h3", name = "Header 3", dscr = "Level 3 header"}, fmt([[
        <h{}>{}</h1>{}
        ]], {
        c(1, {t("3"), fmt([[3 class="{}"]], i(1, "class"), {dedent=false}), t("3")}),
        i(2, "Title"),
        i(0)
    })),

    s(
        {trig = "h4", name = "Header 4", dscr = "Level 4 header"}, fmt([[
        <h{}>{}</h4>{}
        ]], {
        c(1, {t("4"), fmt([[4 class="{}"]], i(1, "class"), {dedent=false}), t("4")}),
        i(2, "Title"),
        i(0)
    })),

    -- Django
    s(
        {trig = "ext", name = "Template tag", dscr = "Django extend template mark"}, fmta([[
        {% extends "<>.html" %}
        ]], {
        i(1, "template")
    })),
    s(
        {trig = "djbl", name = "Block content", dscr = "Django block content"}, fmta([[
        {% block content %}
        <>
        {% endblock content %}
        ]], {
        i(1)
    })),
})

-- extend for htmldjango
require("luasnip").filetype_extend("htmldjango", {"html"})
