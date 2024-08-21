--- Markdown Snippets
return {
  s(
    {
      trig = [[cmd(.+)]],
      trigEngine = "pattern",
      name = "Command section block",
      desc = "Usage: cmd`<the language>`",
    },
    fmt(
      [[
        ```{}
        {}
        ```
        {}]],
      {
        f(function(_, sn) return sn.captures[1] ~= "(.+)" and sn.captures[1] or "" end),
        i(1),
        i(0),
      }
    )
  ),

  s({
    trig = "---",
    name = "Horizontal separator line",
    desc = "A horizontal separation line (79 characters).",
  }, {
    f(function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local width = vim.api.nvim_get_option_value("textwidth", {}) - col - 1
      return string.rep("-", width)
    end),
    t({ "", "" }),
  }),

  s(
    { trig = "imagelink", name = "Image with link", desc = "An image with link" },
    fmt(
      [=[
        [![{fallback}]({image}{hover})]({url}) {}]=],
      {
        fallback = i(1, "fallback text"),
        image = i(2, "image.jpg"),
        hover = c(3, {
          sn(1, { t(' "'), i(1, "hover text"), t('"') }),
          t(""),
        }),
        url = i(4, "url"),
        i(0),
      }
    )
  ),

  s(
    "image",
    fmt("![{}]({}{}){}", {
      i(1, "fallback text"),
      i(2, "image.jpg"),
      c(3, {
        sn(1, { t(' "'), i(1, "hover text"), t('"') }),
        t(""),
      }),
      i(0),
    })
  ),

  s("link", fmt("[{}]({}) {}", { i(1, "Description"), i(2, "url"), i(0) })),
  s("url", fmt("[{}]({}) {}", { i(1, "Description"), i(2, "url"), i(0) })),

  s("ftnote", fmt("[^{}] {}", { i(1), i(0) })),

  s("ic", fmt("`{}` {}", { i(1), i(0) })),

  s(
    { trig = [[(.*)%.%.%.]], trigEngine = "pattern", name = "Puntos suspensivos" },
    f(function(_, snip) return snip.captures[1] .. "…" end, {})
  ),
}
