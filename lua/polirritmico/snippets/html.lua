-- HTML Snippets
local ls = require("luasnip")
local s, t, i, c, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Avoid multiple versions of the same snippet on reload
local reload_key = { key = "my_html_snippets" }

ls.add_snippets("html", {
    -- Headers
    s(
        {trig = "doctype", name = "Docktype", dscr = "Defines the document type"},
        t({"<!DOCTYPE>"})
    ),

    s(
        {trig = "h1", name = "Header 1", dscr = "Level 1 header"}, fmt([[
        {}{}</h1>{}
        ]], {
        c(1, {t("<h1>"), fmt([[<h1 class="{}">]], i(1, "class"))}),
        i(2, "Title"),
        i(0)
    })),

    s(
        {trig = "h2", name = "Header 2", dscr = "Level 2 header"}, fmt([[
        {}{}</h2>{}
        ]], {
        c(1, {t("<h2>"), fmt([[<h2 class="{}">]], i(1, "class"))}),
        i(2, "Title"),
        i(0)
    })),

    s(
        {trig = "h3", name = "Header 3", dscr = "Level 3 header"}, fmt([[
        {}{}</h3>{}
        ]], {
        c(1, {t("<h3>"), fmt([[<h3 class="{}">]], i(1, "class"))}),
        i(2, "Title"),
        i(0)
    })),

    s(
        {trig = "h4", name = "Header 4", dscr = "Level 4 header"}, fmt([[
        {}{}</h4>{}
        ]], {
        c(1, {t("<h4>"), fmt([[<h4 class="{}">]], i(1, "class"))}),
        i(2, "Title"),
        i(0)
    })),

    s(
        {trig = "h5", name = "Header 5", dscr = "Level 5 header"}, fmt([[
        {}{}</h5>{}
        ]], {
        c(1, {t("<h5>"), fmt([[<h5 class="{}">]], i(1, "class"))}),
        i(2, "Title"),
        i(0)
    })),

    s(
        {trig = "h6", name = "Header 6", dscr = "Level 6 header"}, fmt([[
        {}{}</h6>{}
        ]], {
        c(1, {t("<h6>"), fmt([[<h6 class="{}">]], i(1, "class"))}),
        i(2, "Title"),
        i(0)
    })),

    s(
        {trig = "p", name = "Paragraph", dscr = "Adds a paragraph section."}, fmt([[
        {}{}</p>
        ]], {
        c(1, {t("<p>"), fmt([[<p class="{}">]], i(1, "name"))}),
        i(2)
    })),

    s(
        {trig = "div", name = "Div label", dscr = "Adds a div section."}, fmt([[
        {}
            {}
        </div>
        ]], {
        c(1, {t("<div>"), fmt([[<div class="{}">]], i(1, "name"))}),
        i(2)
    })),

    -- Text formatting

    s("b", fmt("<b>{}</b>", i(1))),

    s("strong", fmt("<strong>{}</strong>", i(1))),

    s("i", fmt("<i>{}</i>", i(1))),

    s("em", fmt("<em>{}</em>", i(1))),

    s("mark", fmt("<mark>{}</mark>", i(1))),

    s("small", fmt("<small>{}</small>", i(1))),

    s("del", fmt("<del>{}</del>", i(1))),

    s("ins", fmt("<ins>{}</ins>", i(1))),

    s("sub", fmt("<sub>{}</sub>", i(1))),

    s("sup", fmt("<sup>{}</sup>", i(1))),

    -- Lists

    s(
        {trig = "ul", name = "Unordered List", dscr = "Add unordered list tag"}, fmt([[
        {}
            {}
        </ul>
        ]], {
        c(1, {t("<ul>"), fmt([[<ul class="{}">]], i(1, "classname"))}),
        i(2, "li")
    })),

    s("li", fmt([[<li>{}</li>]], {i(1)})),


    -- Django
    s(
        {trig = "djm", name = "Base tag", dscr = "Django base template mark"}, fmta([[
        {% <> %}
        ]], {
        i(1, "command")
    })),

    s(
        {trig = "djext", name = "Template tag", dscr = "Django extend template mark"}, fmta([[
        {% extends "<>.html" %}
        ]], {
        i(1, "base")
    })),

    s(
        {trig = "djblk", name = "Block content tag", dscr = "Django block content"}, fmta([[
        {% block content %}
        <>
        {% endblock content %}
        ]], {
        i(1)
    })),

    s(
        {trig = "djfor", name = "For tag", dscr = "Django for black content"}, fmta([[
        {% for <> in <> %}
            <>
        {% endfor %}
        ]], {
        i(1, "element"),
        i(2, "model"),
        i(3)
    })),

}, reload_key)

-- extend for htmldjango
require("luasnip").filetype_extend("htmldjango", {"html"})
