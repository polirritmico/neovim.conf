-- Greeter screen
return {
  "nvimdev/dashboard-nvim",
  enabled = true,
  event = "VimEnter",
  opts = function()
    local opts = {
      theme = "doom",
      hide = {
        statusline = false, -- handled by Lualine itself
      },
      config = {
        header = {
          "",
          "",
          [[                               __                ]],
          [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
          [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
          [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
          [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
          [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
          "",
          "",
          "",
        },
        center = {
          {
            action = "ene | startinsert",
            desc = " New file",
            icon = " ",
            key = "e",
          },
          {
            action = "Telescope persisted",
            desc = " Restore Session",
            icon = " ",
            key = "<leader>fs",
          },
          {
            action = "Telescope find_files",
            desc = " Find file",
            icon = " ",
            key = "<leader>ff",
          },
          {
            action = "Telescope oldfiles",
            desc = " Recent files",
            icon = " ",
            key = "<leader>fr",
          },
          {
            action = "Telescope live_grep",
            desc = " Find text",
            icon = " ",
            key = "<leader>fg",
          },
          {
            action = "Telescope help_tags",
            desc = " Help docs",
            icon = "󰘥 ",
            key = "<leader>fh",
          },
          {
            action = [[lua require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })]],
            desc = " Config",
            icon = " ",
            key = "<leader>cc",
          },
          {
            action = "Lazy",
            desc = " Plugins",
            icon = "󰒲 ",
            key = "<leader>cl",
          },
          { action = "qa", desc = " Quit", icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          -- stylua: ignore
          return { "⚡ Neovim loaded "..stats.loaded.."/"..stats.count.." plugins in "..ms.."ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    return opts
  end,
}
