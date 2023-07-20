-- Markdown Snippets
local ls = require("luasnip")
local s, t, i, c, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- Avoid multiple versions of the same snippet on reload
local reload_key = { key = "my_markdown_snippets" }

ls.add_snippets("markdown", {
    s(
        {trig = "cmd", name = "Command section block", dscr = "Command section block in the passed lang.command"}, fmt([[
        ```{}
        {}
        ```
        {}]], {
        c(1, {t("command"), i(1), t("python"), t("sql"), t("bash"), t("html"), t("lua"), t("cpp"), t("json")}),
        i(2),
        i(0)
    })),

    s(
        {trig = "---", name = "Horizontal line",
        dscr = "A horizontal separation line (79 characters)."},
        t("-------------------------------------------------------------------------------")
    ),

    s(
        {trig = "imagelink", name = "Image with link", dscr = "An image with link"}, fmt([=[
        [![{fallback}]({image} "{hover}")]({url}) {}]=], {
        fallback = i(1, "fallback text"),
        image = i(2, "image.jpg"),
        hover = i(3, "hover text"),
        url = i(4, "url"),
        i(0)
    })),

    s("image", fmt("![{}]({} \"{}\") {}", {
        i(1, "fallback text"), i(2, "image.jpg"), i(3, "hover text"), i(0)
    })),

    s("link", fmt("[{}]({}) {}", {i(1, "Description"), i(2, "url"), i(0)})),

    s("ftnote", fmt("[^{}] {}", {i(1), i(0)})),

    s("ic", fmt("`{}` {}", {i(1), i(0)})),
}, reload_key)
