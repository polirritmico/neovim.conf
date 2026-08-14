local utils = require("utils").plugins

return {
  --- The best colorscheme for nvim
  {
    "polirritmico/monokai-nightasty.nvim",
    dev = false and not DisableMyPlugins,
    lazy = false,
    priority = 1000,
    keys = {
      {
        "<leader>tt",
        "<Cmd>MonokaiToggleLight<CR>",
        desc = "Monokai-Nightasty: Toggle dark/light theme.",
      },
    },
    ---@module "monokai-nightasty"
    ---@type monokai.UserConfig
    opts = {
      dark_style_background = "transparent",
      light_style_background = "default",
      color_headers = false,
      lualine_bold = true,
      markdown_header_marks = true,
      cache = true,
      -- hl_styles = {
      --   comments = { italic = true },
      --   floats = "default",
      -- },
      terminal_colors = function(colors) return { fg = colors.fg_dark } end,
    },
    config = function(_, opts)
      vim.opt.cursorline = true -- Highlight line at the cursor position
      vim.o.background = "dark" -- Default to dark theme
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
    "nvimdev/dashboard-nvim",
    cmd = "Dashboard",
    lazy = false,
    opts = function()
      local opts = {
        theme = "doom",
        -- BUG: if set to true, changes laststatus to 2 when changing vim.o.background
        hide = { statusline = false },
        config = {
          vertical_center = true,
          header = { "", [[Neovim :: E B R Λ Y]], [[🄯 2026]], "", "" },
          -- stylua: ignore
          center = {
            { action = "ene | startinsert", desc = " New file", icon = " ", key = "e" },
            { action = utils.mini_sessions_manager, desc = " Restore Session", icon = " ", key = "<leader>ss" },
            { action = utils.oil_explore, desc = " Explore dir", icon = " ", key = "<leader>fe" },
            { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "<leader>fr" },
            { action = "lua require('osv').launch({ port = 8086 })", desc = " Debug session", icon = "󰖷 ", key = "<F10>" },
            { action = "Telescope find_files cwd=~/.config/nvim", desc = " Config files", icon = " ", key = "<leader>cc" },
            { action = "Telescope lazy_plugins", desc = " Config plugins", icon = " ", key = "<leader>cp" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "<leader>cl" },
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
  --- Git: actions
  {
    "tpope/vim-fugitive",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- stylua: ignore
    keymap = {
      { "<leader>gg", vim.cmd.Git, desc = "Fugitive: Git command." },
      { "<leader>gd", "<Cmd>diffget //2<CR>", desc = "Fugitive: Diff get." },
      { "<leader>gp", function() vim.cmd.Git("push") end, ft = "fugitive", desc = "Fugitive: Push." },
      { "<leader>gP", function() vim.cmd.Git("pull", "--rebase") end, ft = "fugitive", desc = "Fugitive: Pull rebase." },
    },
  },
  --- Git: Highlight code changes from last commit
  {
    "lewis6991/gitsigns.nvim",
    enabled = false,
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
      attach_to_untracked = false,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        delay = 500,
        ignore_whitespace = true,
      },
      preview_config = { border = "rounded" },
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      -- stylua: ignore
      on_attach = function(buffer)
        local gs = require("gitsigns")
        local function cmap(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
        end

        local function toggle_gitsigns()
          -- WARN: toggle_current_line_blame should go first or it won't turn off.
          gs.toggle_current_line_blame()
          gs.stage_hunk()
          gs.toggle_word_diff()
        end
        cmap("n", "<leader>gt", toggle_gitsigns, "GitSigns: Toggle show deleted lines")
        cmap("n", "]c", function() gs.nav_hunk("next") end, "GitSigns: Next file change")
        cmap("n", "[c", function() gs.nav_hunk("prev") end, "GitSigns: Previous file change")
        cmap("n", "<leader>gsb", gs.stage_buffer, "GitSigns: Stage buffer")
        cmap({ "n", "v" }, "<leader>gsh", ":Gitsigns stage_hunk<CR>", "GitSigns: Stage hunk")
        cmap({ "n", "v" }, "<leader>grh", ":Gitsigns reset_hunk<CR>", "GitSigns: Reset hunk")
        cmap("n", "<leader>gu", gs.stage_hunk, "GitSigns: Undo stage hunk")
        cmap("n", "<leader>grb", gs.reset_buffer, "GitSigns: Reset buffer")
        cmap("n", "<leader>gP", gs.preview_hunk, "GitSigns: Preview hunk")
        -- cmap("n", "<leader>gK", function() gs.blame_line({ full = true }) end, "GitSigns: Blame line")
        cmap("n", "<leader>gC", gs.toggle_current_line_blame, "GitSigns: Toggle current line blame")
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
      { "<A-ñ>", function() require("harpoon"):list():select(4) end, desc = "Harpoon: Open tagged file 4", silent = true },
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
    -- FIX: After this commit the status bar is visible in the dashboard
    commit = "1517caa",
    event = "VeryLazy",
    opts = function()
      -- PERF: Replace lualine_require (wtf?!) with nvim require
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local custom_section_y = not Workstation and { "progress" }
        or { "progress", utils.lualine_harpoon() }

      return {
        options = {
          section_separators = { left = "", right = "" },
          component_separators = "⏽",
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
  --- Notifications
  {
    "nvim-mini/mini.notify",
    version = "*",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      lsp_progress = {
        duration_last = 2000,
      },
      window = {
        config = function()
          local has_statusline = vim.o.laststatus > 0
          local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
          return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad }
        end,
        max_width_share = 0.6,
        winblend = 0,
      },
    },
  },
  --- Shows code context on the top (func, classes, etc.)
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter" },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      min_window_height = 10, -- in lines
      max_lines = 3, -- max number of lines of the header context
    },
  },
}
