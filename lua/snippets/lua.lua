--- Lua Snippets
return {
  s(
    {
      trig = "require",
      name = "Require snippet",
      dscr = "Set the variable name to the last require.",
    },
    fmt(
      [[
        local {} = require("{}"){}]],
      {
        f(function(import_name)
          -- local parts = vim.split(import_name[1][1], ".", true)
          local parts = vim.split(import_name[1][1], ".", { plain = true })
          return parts[#parts] or ""
        end, { 1 }),
        i(1),
        i(0),
      }
    )
  ),

  s(
    { trig = "layoutsnippet", dscr = "Meta-snippet to make snippets." },
    fmt("{}", {
      c(1, {
        fmt(
          [=[
                s("{}", fmt({}, {{{}}})),]=],
          {
            i(1),
            i(2, '"snippet"'),
            i(3),
          }
        ),
        fmt(
          [=[
                s(
                    {{trig = "{}", name = "{}", dscr = "{}"}}, fmt([[
                    {}
                    ]], {{
                    {}
                }})),]=],
          {
            i(1),
            i(2, "Name"),
            i(3, "Description"),
            i(4),
            i(5),
          }
        ),
      }),
    })
  ),

  s(
    {
      trig = "layoutmapnvim",
      name = "Add keymap",
      dscr = "Layout for adding custom keymaps using Neovim API.",
    },
    fmta([[vim.keymap.set(<mode>, "<lhs>", <rhs><options> )]], {
      mode = c(1, {
        t('{ "n" }'),
        t('{ "n", "v" }'),
        t('{ "v" }'),
        t('{ "i" }'),
        { t('"'), i(1), t('"') },
        i(1),
      }),
      lhs = c(2, {
        sn(1, { t("<leader>"), r(1, "user_lhs") }),
        sn(1, { r(1, "user_lhs") }),
      }),
      rhs = c(3, {
        { t('"<Cmd>'), r(1, "user_rhs"), t('<CR>"') },
        { t("function() "), r(1, "user_rhs"), t(" end") },
        { r(1, "user_rhs") },
      }),
      options = c(4, {
        t(", { silent = true }"),
        { t(', { silent = true, desc = "'), i(1), t('" }') },
        { t(', { desc = "'), i(1), t('"}') },
        { t(", { "), i(1), t(" }") },
      }),
    }),
    {
      stored = {
        ["user_lhs"] = i(1, "lhs"),
        ["user_rhs"] = i(1, "rhs"),
      },
    }
  ),

  s(
    {
      trig = "lazymap",
      name = "Lazy layout keymap",
      dscr = "Layout for adding custom keymaps using the Lazy key spec.",
    },
    fmta([[{ "<lhs>", <rhs><mode><ft>, desc = "<desc>" },]], {
      lhs = c(1, {
        sn(1, { t("<leader>"), r(1, "user_lhs") }),
        sn(1, { r(1, "user_lhs") }),
      }),
      rhs = c(2, {
        { t('"<Cmd>'), r(1, "user_rhs"), t('<CR>"') },
        { t("function() "), r(1, "user_rhs"), t(" end") },
        { r(1, "user_rhs") },
      }),
      mode = c(3, {
        t(', mode = { "n", "v" }'),
        t(""),
      }),
      ft = c(4, {
        { t(', ft = "'), r(1, "user_ft"), t('"') },
        t(""),
      }),
      desc = i(5, "Plugin_Name: Description."),
    }),
    {
      stored = {
        ["user_lhs"] = i(1, "lhs"),
        ["user_rhs"] = i(1, "rhs"),
        ["user_ft"] = i(1, "filetype"),
      },
    }
  ),

  s({
    trig = "---",
    name = "Horizontal separator line",
    dscr = "A horizontal separation line (79 characters).",
  }, {
    f(function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local width = vim.api.nvim_get_option_value("textwidth", {}) - col - 1
      return string.rep("-", width)
    end),
    t({ "" }),
  }),

  s(
    { trig = "lazyevent", dscr = "Add common lazy enter buffer event" },
    t([[event = { "BufReadPost", "BufWritePost", "BufNewFile" },]])
  ),

  s(
    {
      trig = "layoutunittest",
      name = "Unit test",
      dscr = "Plenary unit test",
    },
    fmt(
      [=[
        it("{}", function()
          local case = [[{}]]
          local expected = h.clean_text_format([[{}]])

          {}

          local output = h.get_buffer_content(bufnr)
          assert.same(expected, output)
        end)
      ]=],
      {
        i(1, "Test name"),
        i(2),
        i(3),
        i(4, "plugin.foo(case)"),
      }
    )
  ),
}
