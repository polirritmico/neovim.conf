return {
  "polirritmico/telescope-lazy-plugins.nvim",
  cmd = "Telescope lazy_plugins",
  keys = {
    { "<leader>cp", "<Cmd>Telescope lazy_plugins<CR>", desc = "Lazy Plugins" },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local my_opts = {
        lazy_plugins = {
          show_disabled = true,
        },
      }
      opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, my_opts)
    end,
  },
  enabled = true,
}
