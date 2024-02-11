--- Markdown Snippets
local ls = require("luasnip")
local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

-- Avoid multiple versions of the same snippet on reload
local reload_key = { key = "my_markdown_snippets" }

ls.add_snippets("markdown", {
  s(
    {
      trig = "cmd",
      name = "Command section block",
      dscr = "Command section block in the passed lang.command",
    },
    fmt(
      [[
        ```{}
        {}
        ```
        {}]],
      {
        c(1, {
          t("command"),
          i(1),
          t("bash"),
          t("lua"),
          t("python"),
          t("html"),
          t("sql"),
          t("cpp"),
          t("json"),
        }),
        i(2),
        i(0),
      }
    )
  ),

  s(
    {
      trig = "----",
      name = "Horizontal line",
      dscr = "A horizontal separation line (79 characters).",
    },
    t("-------------------------------------------------------------------------------")
  ),

  s(
    { trig = "imagelink", name = "Image with link", dscr = "An image with link" },
    fmt(
      [=[
        [![{fallback}]({image} "{hover}")]({url}) {}]=],
      {
        fallback = i(1, "fallback text"),
        image = i(2, "image.jpg"),
        hover = i(3, "hover text"),
        url = i(4, "url"),
        i(0),
      }
    )
  ),

  s(
    "image",
    fmt('![{}]({} "{}") {}', {
      i(1, "fallback text"),
      i(2, "image.jpg"),
      i(3, "hover text"),
      i(0),
    })
  ),

  s("link", fmt("[{}]({}) {}", { i(1, "Description"), i(2, "url"), i(0) })),

  s("ftnote", fmt("[^{}] {}", { i(1), i(0) })),

  s("ic", fmt("`{}` {}", { i(1), i(0) })),

  s({ trig = "...", name = "Puntos suspensivos" }, t("…")),

  s({
    trig = "dlg",
    name = "Diálogo",
    dscr = "Inserta un diálogo con el símbolo correcto.",
  }, {
    c(1, {
      { t("—"), r(1, "user_text") },
      { t("—"), r(1, "user_text"), t("—") },
    }),
  }, {
    stored = {
      ["user_text"] = i(1),
    },
  }),
}, reload_key)
