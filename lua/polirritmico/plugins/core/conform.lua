--- Formatter
return {
  "stevearc/conform.nvim",
  enabled = true,
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<F3>",
      function()
        require("conform").format({ async = false, lsp_fallback = true })
      end,
      mode = "",
      desc = "Conform: Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      ["*"] = { "trim_whitespace" },
      css = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
      sh = { "shfmt" },
    },
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters = {
      black = { prepend_args = { "--line-length", "88" } },
      prettier = { prepend_args = { "--tab-width", "2" } },
      shfmt = { prepend_args = { "-i", "4" } },
      stylua = { prepend_args = { "--indent-type", "Spaces" } }, -- overwrites stylua.toml
    },
  },
  init = function()
    vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
  end,
}
