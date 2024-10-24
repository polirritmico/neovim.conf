return {
  --- Best colorscheme for nvim
  {
    "polirritmico/monokai-nightasty.nvim",
    dev = false,
    lazy = false,
    priority = 1000,
    keys = {
      {
        "<leader>tt",
        "<Cmd>MonokaiToggleLight<CR>",
        desc = "Monokai-Nightasty: Toggle dark/light theme.",
      },
    },
    ---@type monokai.UserConfig
    opts = {
      dark_style_background = "transparent",
      light_style_background = "default",
      color_headers = false,
      lualine_bold = true,
      markdown_header_marks = true,
      cache = true,
      -- hl_styles = { comments = { italic = false } },
      terminal_colors = function(colors) return { fg = colors.fg_dark } end,
    },
    config = function(_, opts)
      vim.opt.cursorline = true -- Highlight line at the cursor position
      vim.o.background = "dark" -- Default to dark theme

      -- Open new Nvim instance with light theme between the range time
      -- if require("utils").config.in_hours_range(1400, 1630) then
      --   vim.o.background = "light"
      -- end

      require("monokai-nightasty").load(opts)
    end,
  },
  --- Custom vertical width column/ruler
  {
    "lukas-reineke/virt-column.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = { char = "┊" },
  },
  --- Delete buffers without messing up the current layout
  {
    "famiu/bufdelete.nvim",
    keys = {
      {
        "<leader>db",
        function() require("bufdelete").bufdelete(0, true) end,
        { "n", "v" },
        desc = "bufdelete: Fercibly delete the current buffer.",
        silent = true,
      },
    },
  },
  --- Greeter screen
  {
    "polirritmico/dashboard-nvim", -- nvimdev/dashboard-nvim
    cmd = "Dashboard",
    lazy = false,
    opts = function()
      local opts = {
        theme = "doom",
        hide = { statusline = true },
        config = {
          vertical_center = true,
          header = {
            "",
            [[Neovim :: E B R Λ Y]],
            [[🄯 2024]],
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
              action = require("utils.plugins").mini_sessions_manager,
              desc = " Restore Session",
              icon = " ",
              key = "<leader>ss",
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
              action = "lua require('osv').launch({ port = 8086 })",
              desc = " Debug session",
              icon = "󰖷 ",
              key = "<F10>",
            },
            {
              action = "Telescope find_files cwd=~/.config/nvim",
              desc = " Config files",
              icon = " ",
              key = "<leader>cc",
            },
            {
              action = "Telescope lazy_plugins",
              desc = " Config plugins",
              icon = " ",
              key = "<leader>cp",
            },
            {
              action = "Lazy",
              desc = " Lazy",
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
  --- Git: Highlight code changes from last commit
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" }, -- │
        change = { text = "│" }, -- │
        delete = { text = "-" }, -- _
        topdelete = { text = "‾" }, -- ‾
        changedelete = { text = "~" }, -- ~
        untracked = { text = "┆" }, -- ┆
      },
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        delay = 500,
        ignore_whitespace = true,
      },
      preview_config = { border = "rounded" },
      show_deleted = false,
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      attach_to_untracked = false,
      -- stylua: ignore
      on_attach = function(buffer)
        local gs = require("gitsigns")
        local function cmap(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
        end

        local function toggle_gitsigns()
          -- WARN: toggle_current_line_blame should go first or it won't turn off.
          gs.toggle_current_line_blame()
          gs.toggle_deleted()
          gs.toggle_word_diff()
        end
        cmap("n", "<leader>tg", toggle_gitsigns, "GitSigns: Toggle show deleted lines")
        cmap("n", "]c", gs.next_hunk, "GitSigns: Next file change")
        cmap("n", "[c", gs.prev_hunk, "GitSigns: Previous file change")
        cmap("n", "<leader>gsb", gs.stage_buffer, "GitSigns: Stage buffer")
        cmap({ "n", "v" }, "<leader>gsh", ":Gitsigns stage_hunk<CR>", "GitSigns: Stage hunk")
        cmap({ "n", "v" }, "<leader>grh", ":Gitsigns reset_hunk<CR>", "GitSigns: Reset hunk")
        cmap("n", "<leader>gu", gs.undo_stage_hunk, "GitSigns: Undo stage hunk")
        cmap("n", "<leader>grb", gs.reset_buffer, "GitSigns: Reset buffer")
        cmap("n", "<leader>gP", gs.preview_hunk, "GitSigns: Preview hunk")
        cmap("n", "<leader>gK", function() gs.blame_line({ full = true }) end, "GitSigns: Blame line")
        cmap("n", "<leader>gc", gs.toggle_current_line_blame, "GitSigns: Toggle current line blame")
        cmap("n", "<leader>gd", gs.diffthis, "GitSigns: Diff this")
        cmap("n", "<leader>gD", function() gs.diffthis("~") end, "GitSigns: Diff this")
      end,
    },
  },
  --- Git: Improved commits screen
  {
    "rhysd/committia.vim",
    ft = { "gitcommit" },
  },
  --- Harpoon: Navigation through pinned files
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = { save_on_toggle = true },
    },
    -- stylua: ignore
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon: Add current buffer to the tagged files list", silent = true },
      { "<A-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: Open tagged files list", silent = true },
      { "<A-j>", function() require("harpoon"):list():select(1) end, desc = "Harpoon: Open tagged file 1", silent = true },
      { "<A-k>", function() require("harpoon"):list():select(2) end, desc = "Harpoon: Open tagged file 2", silent = true },
      { "<A-l>", function() require("harpoon"):list():select(3) end, desc = "Harpoon: Open tagged file 3", silent = true },
      { "<A-h>", function() require("harpoon"):list():select(4) end, desc = "Harpoon: Open tagged file 4", silent = true },
    },
  },
  --- Indentation guide lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      exclude = { filetypes = { "dashboard" } },
      indent = {
        char = { "│" },
        smart_indent_cap = false, -- Get indent level by surrounding code
      },
      scope = { enabled = false },
    },
  },
  --- Lualine: Status bar
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function()
      -- PERF: Replace lualine_require (wtf?!) with nvim require
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local custom_section_y = not Workstation and { "progress" }
        or { "progress", require("utils").plugins.lualine_harpoon() }

      return {
        options = {
          disabled_filetypes = { statusline = { "dashboard", "man" } },
        },
        extensions = { "lazy" },
        sections = {
          lualine_c = { { "filename", path = 1 } }, -- show parent directory
          lualine_y = custom_section_y,
        },
      }
    end,
  },
  --- Noice. A lot of ui messages
  {
    "folke/noice.nvim",
    -- FIX: cmdline cursor flickr: https://github.com/folke/noice.nvim/issues/953
    version = "4.4.7",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = { enabled = false },
      messages = { enabled = false },
      popupmenu = { enabled = false },
      notify = { enabled = false },
      lsp = {
        -- Override markdown rendering so that cmp and other plugins use Treesitter
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = { enabled = true, silent = false },
        signature = { enabled = true },
      },
      presets = { lsp_doc_border = true }, -- signature and hover docs border
      views = { mini = { position = { row = -2 } } }, -- diagnostic workspace msgs
    },
    config = function(_, opts)
      require("noice").setup(opts)

      local n_docs = require("noice.lsp.docs")
      local hide_signature = function() n_docs.hide(n_docs.get("signature")) end
      -- stylua: ignore
      vim.keymap.set("i", "<C-e>", hide_signature, { desc = "Noice: Hide signature info" } )
    end,
  },
  --- Shows code context on the top (func, classes, etc.)
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      min_window_height = 10, -- in lines
      max_lines = 3, -- max number of lines of the header context
    },
  },
}
