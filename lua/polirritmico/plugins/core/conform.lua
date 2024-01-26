--- Formatter
return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<F3>",
      function()
        require("conform").format({ async = false, lsp_fallback = true })
      end,
      mode = { "n", "v" },
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
    format_on_save = function(bufnr)
      -- Only apply format if `disable_autoformat` is not true
      if not (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat) then
        return { timeout_ms = 500, lsp_fallback = true }
      end
    end,
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
  config = function(_, opts)
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- :FormatDisable!<CR>
        vim.b[0].disable_autoformat = true
        vim.notify("Disabled autoformat-on-save just for the current buffer.")
      else
        -- :FormatDisable<CR>
        vim.g.disable_autoformat = true
        vim.notify("Disabled autoformat-on-save.")
      end
    end, {
      desc = "Disable autoformat-on-save. Append `!` to affect only the current buffer.",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b[0].disable_autoformat = false
      vim.g.disable_autoformat = false
      vim.notify("Enabled autoformat-on-save.")
    end, {
      desc = "Enable autoformat-on-save",
    })

    require("conform").setup(opts)
  end,
}
