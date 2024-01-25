--- Lsp function hover
return {
  "ray-x/lsp_signature.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  enabled = true,
  -- event = "VeryLazy",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {
    floating_window_above_cur_line = true,
    close_timeout = 2000,
    hint_prefix = " ",
    toggle_key = "<A-i>",
    toggle_key_flip_floatwin_setting = true,
  },
}
