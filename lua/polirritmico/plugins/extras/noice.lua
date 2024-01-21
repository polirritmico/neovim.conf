return {
  "folke/noice.nvim",
  -- enabled = false,
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    cmdline = { enabled = false },
    messages = { enabled = false },
    popupmenu = { enabled = false },
    notify = { enabled = false },
    progress = { enabled = true },
    lsp = {
      -- Override markdown rendering so that cmp and other plugins use Treesitter
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = true,
        silent = false, -- true for not show msg if hover is not avaliable
        -- opts = { border = "rounded" },
      },
      signature = { enabled = false },
    },
    presets = { lsp_doc_border = true }, -- signature and hover docs border
    views = { mini = { position = { row = -2 } } }, -- diagnostic workspace msgs
    -- Filter messages
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      {
        filter = {
          event = "lsp",
          find = "lint",
        },
        opts = { skip = true },
      },
    },
  },
  config = function(_, opts)
    vim.diagnostic.config({ update_in_insert = false })
    require("noice").setup(opts)
  end,
}
