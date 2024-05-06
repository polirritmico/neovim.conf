--- Markdown Snippets
return {
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

  s({
    trig = "---",
    name = "Horizontal separator line",
    dscr = "A horizontal separation line (79 characters).",
  }, {
    f(function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local width = vim.api.nvim_get_option("textwidth") - col - 1
      return string.rep("-", width)
    end),
    t({ "", "" }),
  }),

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

  s(
    { trig = [[(.*)%.%.%.]], trigEngine = "pattern", name = "Puntos suspensivos" },
    f(function(_, snip) return snip.captures[1] .. "…" end, {})
  ),
}
