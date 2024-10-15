return {
  --- Fix close {} indentation for Python
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },
  --- Handle system Files
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      local oil_open_folder = function(path) require("oil").open(path) end
      require("utils").autocmd.attach_file_browser("oil", oil_open_folder)
      require("utils").plugins.oil_confirmation_key({ "y", "s" })
    end,
    cmd = { "Oil" },
    -- stylua: ignore
    keys = {
      { "<leader>fe", "<Cmd>Oil .<CR>", desc = "Oil: File explorer from nvim path" },
      { "<leader>fE", "<Cmd>Oil %:p:h<CR>", desc = "Oil: File explorer mode from buffer path." },
    },
    opts = {
      buf_options = { buflisted = true },
      keymaps = {
        ["_"] = "actions.select",
        ["<C-h>"] = "actions.toggle_hidden",
        ["<leader>cd"] = "actions.cd",
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        is_always_hidden = function(name, _) return name == ".." or name == ".git" end,
        natural_order = true,
        show_hidden = true,
      },
    },
  },
  --- Surround operations
  {
    "kylechui/nvim-surround",
    version = "*", -- latest stable
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { "<leader>mb", function() vim.cmd("normal siw*l.") end, mode = "n", ft = "markdown", desc = "Markdown: Bold text." },
      { "<leader>mi", function() vim.cmd("normal siw_") end, mode = "n", ft = "markdown", desc = "Markdown: Italic text." },
      { "<leader>mc", function() vim.cmd("normal siw`") end, mode = "n", ft = "markdown", desc = "Markdown: Code text." },
    },
    opts = {
      keymaps = {
        -- Change the mappings, there is no reason to keep `s`
        normal = "s",
        normal_cur = "ss",
        normal_cur_line = "sS",
        visual = "s",
        visual_line = "S",
      },
    },
  },
  --- Session manager
  {
    "echasnovski/mini.sessions",
    -- stylua: ignore
    keys = {
      { "<leader>ss", require("utils").plugins.mini_sessions_manager, desc = "mini.sessions: Select a session." },
    },
    opts = {
      directory = vim.fn.stdpath("state") .. "/sessions",
      file = ".Sessions.vim",
      verbose = { read = true, write = true, delete = true },
    },
  },
  --- TODO, FIX, etc. comments highlights
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope" },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "todo-comments: Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "todo-comments: Previous todo comment" },
      { "<leader>ft", "<Cmd>TodoTelescope<CR>", desc = "todo-comments: Open todo list in telescope" },
    },
    opts = {
      keywords = {
        FIX = { icon = "", alt = { "FIXME", "BUG", "ISSUE", "ERROR" } },
        HACK = { icon = "" },
        NOTE = { icon = "󰍨", alt = { "INFO", "NOTA" } },
        PERF = { icon = "󰅒", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        TEST = { icon = "", alt = { "TESTING" } },
        TODO = { icon = "󰑕" },
        WARN = { icon = "", alt = { "WARNING" } },
      },
      highlight = {
        pattern = [[^\s*\S{1,2}\s<(KEYWORDS)\s*:]], -- default: [[\b(KEYWORDS):]]
      },
    },
  },
  --- Toggle boolean values
  {
    "polirritmico/simple-boolean-toggle.nvim",
    cond = true,
    dev = false,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { "<leader>tB", "<Cmd>lua require('simple-boolean-toggle').toggle_builtins()<Cr>", desc = "Boolean Toggle: Enable/Disable the builtin overwrite" },
    },
    opts = {},
  },
  --- Undo history tree
  {
    "mbbill/undotree",
    init = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_TreeNodeShape = "●"
      vim.g.undotree_TreeReturnShape = "╲"
      vim.g.undotree_TreeSplitShape = "╱"
      vim.g.undotree_TreeVertShape = "│"
      vim.g.undotree_WindowLayout = 3 -- 3: right-align. 4: same with diff full bottom
    end,
    keys = {
      { "<leader>tu", vim.cmd.UndotreeToggle, desc = "UndoTree: Toggle" },
    },
  },
}
