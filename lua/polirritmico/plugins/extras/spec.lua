--- Greeter screen
return {
  {
    "nvimdev/dashboard-nvim",
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
              action = "Telescope lazy_plugins",
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
  },
  --- Noice. A lot of ui messages
  {
    "folke/noice.nvim",
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
  },
  --- Center buffer on screen
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    enabled = true,
    cmd = "NoNeckPain",
    opts = {
      autocmds = {
        reloadOnColorSchemeChange = true,
      },
      buffers = {
        bo = { filetype = "md" },
        right = { enabled = false },
        wo = { fillchars = "eob: " }, -- Hide ~ from spacebuffers
      },
      width = 100,
    },
    keys = function()
      NoNeckPain_default_border_hl = {}
      NoNeckPainToggleState = false

      local function NNP_toggle_with_custom_border_hl()
        local border_name = "WinSeparator"
        local custom_hl = { fg = 4079166 } -- "#3e3e3e" in dec

        if NoNeckPain_default_border_hl.fg == nil then
          NoNeckPain_default_border_hl =
            vim.api.nvim_get_hl(0, { name = border_name, link = true })
        end

        if NoNeckPainToggleState then
          vim.api.nvim_set_hl(0, border_name, NoNeckPain_default_border_hl)
        else
          vim.api.nvim_set_hl(0, border_name, custom_hl)
        end
        NoNeckPainToggleState = not NoNeckPainToggleState
        vim.cmd([[NoNeckPain]])
      end

      return {
        {
          "<leader>tc",
          NNP_toggle_with_custom_border_hl,
          { "n", "s" },
          desc = "NoNeckPain: Toggle center mode",
          silent = true,
        },
      }
    end,
  },
  --- Treesitter full `ensure_installed` list
  {
    "nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "comment",
        "diff",
        "gitcommit",
        "html",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "sql",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },
  --- Active indent guide. Animates the highlight
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      options = { try_as_border = true },
      symbol = "│",
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "dashboard",
          "neo-tree",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
