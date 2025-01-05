return {
  {
    "folke/snacks.nvim",
    priority = 999,
    lazy = false,
    cond = false,
    keys = {
      {
        "<leader>ps",
        function() Snacks.profiler.scratch() end,
        desc = "Profiler Scratch Buffer",
      },
    },
    opts = function()
      Snacks.toggle.profiler():map("<leader>pp")
      Snacks.toggle.profiler_highlights():map("<leader>ph")
      return {
        notifier = { enabled = true },
        profiler = {
          pick = { preview = { align = "left" } },
        },
        dashboard = {
          preset = {
            header = "Neovim :: E B R Λ Y\n🄯 2024",
          -- stylua: ignore
          keys = {
            { icon = " ", key = "e", desc = "New file", action = ":ene | startinsert" },
            { icon = " ", key = "<leader>ss", desc = "Restore Session", action = require("utils.plugins").mini_sessions_manager },
            { icon = " ", key = "<leader>ff", desc = "Find file", action = ":Telescope find_files" },
            { icon = " ", key = "<leader>fr", desc = "Recent files", action = ":Telescope oldfiles" },
            { icon = "󰖷 ", key = "<F10>", desc = "Debug session", action = ":lua require('osv').launch({ port = 8086 })" },
            { icon = " ", key = "<leader>cc", desc = "Config files", action = ":Telescope find_files cwd=~/.config/nvim" },
            { icon = " ", key = "<leader>cp", desc = "Config plugins", action = ":Telescope lazy_plugins" },
            { icon = "󰒲 ", key = "<leader>cl", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          },
        },
      }
    end,
  },
}
