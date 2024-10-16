return {
  s({
    trig = "---",
    name = "Horizontal separator line",
    dscr = "Add a comment line separator.",
  }, {
    f(function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local width = vim.api.nvim_get_option_value("textwidth", {}) - col - 2
      return "%" .. string.rep("-", width)
    end),
    t({ "", "" }),
  }),
}
