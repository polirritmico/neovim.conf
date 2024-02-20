--- Delete buffers without messing up the current layout
return {
  {
    "famiu/bufdelete.nvim",
    event = "VeryLazy",
    keys = function()
      return {
        {
          "<leader>db",
          function()
            require("bufdelete").bufdelete(0, true)
          end,
          { "n", "v" },
          desc = "bufdelete: Fercibly delete the current buffer.",
          silent = true,
        },
      }
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
        cmap("n", "<leader>gt", toggle_gitsigns, "GitSigns: Toggle show deleted lines")
        cmap("n", "<leader>gn", gs.next_hunk, "GitSigns: Next file change")
        cmap("n", "<leader>gp", gs.prev_hunk, "GitSigns: Previous file change")
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
  --- Harpoon: Navigation through pinned files
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    event = "VeryLazy",
    keys = function()
      local harpoon = require("harpoon")
      -- stylua: ignore
      return {
        { "<leader>a", function() harpoon:list():append() end, desc = "Harpoon: Add current buffer to the tagged files list", silent = true },
        { "<A-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon: Open tagged files list", silent = true },
        { "<A-j>", function() harpoon:list():select(1) end, desc = "Harpoon: Open tagged file 1", silent = true },
        { "<A-k>", function() harpoon:list():select(2) end, desc = "Harpoon: Open tagged file 2", silent = true },
        { "<A-l>", function() harpoon:list():select(3) end, desc = "Harpoon: Open tagged file 3", silent = true },
        { "<A-h>", function() harpoon:list():select(4) end, desc = "Harpoon: Open tagged file 4", silent = true },
      }
    end,
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
  --- Lsp function hover
  {
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

      return {
        options = {
          disabled_filetypes = { statusline = { "dashboard" } },
          theme = "monokai-nightasty",
        },
        extensions = { "lazy" },
      }
    end,
  },
  --- Best colorscheme for nvim
  -- To reload use `:Lazy reload monokai-nightasty.nvim`
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
    opts = {
      dark_style_background = "transparent",
      light_style_background = "default",
      color_headers = false,
      lualine_bold = true,
      lualine_style = "default",
      -- hl_styles = { comments = { italic = false } },
    },
    config = function(_, opts)
      vim.opt.cursorline = true -- Highlight line at the cursor position
      vim.o.background = "dark" -- Default to dark theme

      -- Change to light between time
      local date_output = vim.api.nvim_exec2("!date +'\\%H\\%M'", { output = true })
      local system_time = tonumber(string.match(date_output["output"], "%d%d%d%d"))
      if system_time >= 1400 and system_time < 1930 then
        vim.o.background = "light"
      end

      require("monokai-nightasty").load(opts)
    end,
  },
  --- Shows code context on the top (func, classes, etc.)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      min_window_height = 10, -- in lines
      max_lines = 3, -- max number of lines of the header context
    },
  },
  --- Custom vertical width column/ruler
  {
    "lukas-reineke/virt-column.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = { char = "┊" },
  },
}