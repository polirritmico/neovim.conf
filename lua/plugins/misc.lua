return {
  --- Git: Improved commits screen
  {
    "rhysd/committia.vim",
    ft = { "gitcommit" },
  },
  --- Apply local patches to plugins installed through lazy.nvim
  {
    "polirritmico/lazy-local-patcher.nvim",
    config = true,
    dev = false,
    ft = "lazy",
  },
  --- Aerial: Code components quick navigation
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    -- stylua: ignore
    keys = {
      -- { "<leader>fa", "<Cmd>AerialToggle! float<CR>", desc = "Aerial: Toggle TOC" },
      { "<leader>fa", "<Cmd>AerialToggle!<CR>", desc = "Aerial: Toggle TOC" },
      { "<leader>fn", "<Cmd>AerialNavToggle<CR>", desc = "Aerial: navigation" },
    },
    opts = {
      -- stylua: ignore
      on_attach = function(bn)
        vim.keymap.set("n", "g{", "<Cmd>AerialPrev<CR>", { buffer = bn, desc = "Aerial: Jump backwards" })
        vim.keymap.set("n", "g}", "<Cmd>AerialNext<CR>", { buffer = bn, desc = "Aerial: Jump forwards" })
      end,
      layout = {
        min_width = 20,
        default_direction = "prefer_left", -- prefer_right, prefer_left, right, left, float
        placement = "edge", -- window, edge (of screen)
      },
      float = {
        relative = "win",
        override = function(conf, winid)
          local padding = 1
          conf.anchor = "NE"
          conf.row = padding
          conf.col = vim.api.nvim_win_get_width(winid) - padding
          return conf
        end,
      },
      nav = {
        win_opts = { winblend = 0 },
      },
    },
  },
}
