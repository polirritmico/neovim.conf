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
    end,
    cmd = { "Oil" },
    -- stylua: ignore
    keys = {
      { "<leader>fe", "<Cmd>Oil .<CR>", desc = "Oil: File explorer from nvim path" },
      { "<leader>fE", "<Cmd>Oil %:p:h<CR>", desc = "Oil: File explorer mode from buffer path." },
    },
    opts = {
      buf_options = { buflisted = true },
      keymaps = { ["_"] = "actions.select", ["<C-h>"] = "actions.toggle_hidden" },
    },
  },
  --- Pairs of (), [], {}, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "nvim-cmp" },
    opts = {
      enable_check_bracket_line = true,
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'", "`" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "L",
        keys = "asdfghjklqwertyuiopzxcvbnm",
        check_comma = true,
        manual_position = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      npairs.setup(opts)

      -- Add symmetrical spaces:
      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules({
        Rule(" ", " ")
          :with_pair(function(_opts)
            local pair = _opts.line:sub(_opts.col - 1, _opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          :with_del(function(_opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = _opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
              brackets[1][1] .. "  " .. brackets[1][2],
              brackets[2][1] .. "  " .. brackets[2][2],
              brackets[3][1] .. "  " .. brackets[3][2],
            }, context)
          end),
      })
      for _, bracket in pairs(brackets) do
        Rule("", " " .. bracket[2])
          :with_pair(cond.none())
          :with_move(function(_opts) return _opts.char == bracket[2] end)
          :with_cr(cond.none())
          :with_del(cond.none())
          :use_key(bracket[2])
      end

      -- Integrate with cmp: Insert "(" after select function or method item
      if require("lazy.core.config").plugins["nvim-cmp"] ~= nil then
        require("cmp").event:on(
          "confirm_done",
          require("nvim-autopairs.completion.cmp").on_confirm_done()
        )
      end
    end,
  },
  --- Surround operations
  {
    "kylechui/nvim-surround",
    version = "*", -- latest stable
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      -- TODO: While learning this maps I'm keeping the defaults on the right.
      -- Remove in a few months.
      keymaps = {
        -- Change the mappings, there is no reason to keep `s`.
        normal = "s", -- ys
        normal_cur = "ss", -- yss
        normal_cur_line = "sS", -- ySS
        visual = "s", -- S
        visual_line = "S", -- gS
      },
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
      -- Style test:
      -- FIX: Some text
      -- HACK: Some text
      -- NOTE: Some text
      -- PERF: Some text
      -- TEST: Some text
      -- TODO: Some text
      -- WARNING: Some text
      keywords = {
        -- Alternative icons:       󰈸  󱗗 
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
    enabled = true,
    dev = true,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { "<leader>tB", "<Cmd>lua require('simple-boolean-toggle').toggle_builtins()<Cr>", desc = "Boolean Toggle: Enable/Disable the builtin overwrite" },
    },
    opts = {},
  },
}
