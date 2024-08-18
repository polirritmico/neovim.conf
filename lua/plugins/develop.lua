return {
  --- DAP: Debugger connector
  {
    {
      "mfussenegger/nvim-dap",
      version = "*",
      -- stylua: ignore
      keys = {
        { "<F5>", function() require("dap").continue() end, desc = "DAP: Continue execution" },
        { "<F6>", function() require("dap").pause() end, desc = "DAP: Pause execution" },
        { "<F7>", function() require("dap").step_out() end, desc = "DAP: Step out" },
        { "<F8>", function() require("dap").step_into() end, desc = "DAP: Step into" },
        { "<F9>", function() require("dap").step_over() end, desc = "DAP: Step over" },
        { "<F12>", function() require("dap").close() end, desc = "DAP: Close execution" },
        { "<Leader>dc", function() require("dap").repl.open() end, desc = "DAP: Open debug console" },
        { "<Leader>dr", function() require("dap").run_last() end, desc = "DAP: Rerun last debug adapter/config" },
        { "<Leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP: Add/remove breakpoint into the current line" },
        { "<Leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP: Add a conditional breakpoint" },
        { "<Leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "DAP: Add a logpoint into the current line" },
      },
      dependencies = {
        {
          "mfussenegger/nvim-dap-python",
          ft = "python",
          dependencies = "mason.nvim",
          config = function()
            local debugpy = require("mason-registry").get_package("debugpy")
            local python_path = debugpy:get_install_path() .. "/venv/bin/"
            require("dap-python").setup(python_path .. "python")
            require("dap-python").test_runner = "pytest"
          end,
          -- stylua: ignore
          keys = {
            { "<Leader>rtd", function() require("dap-python").test_method() end, ft = "python", desc = "DAP: Run test method" },
          },
        },
        {
          "jbyuki/one-small-step-for-vimkind",
          config = function()
            local dap = require("dap")
            dap.adapters.nlua = function(callback, config)
              ---@diagnostic disable [undefined-field]
              callback({
                type = "server",
                host = config.host or "127.0.0.1",
                port = config.port or 8086,
              })
            end
            dap.configurations.lua = {
              {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
              },
            }
          end,
          keys = {
            -- stylua: ignore
            { "<F10>", function() require("osv").launch({port = 8086}) end, mode = { "n", "v" }, desc = "DAP: (Lua) Launch Server." },
          },
        },
      },
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-dap", "nvim-neotest/nvim-nio" },
      -- stylua: ignore
      keys = {
        { "<Leader>dk", function() require("dapui").eval() end, desc = "DAP: Show debug info of the element under the cursor" },
        { "<Leader>dg", function() require("dapui").toggle() end, desc = "DAP: Toggle DAP GUI" },
        { "<Leader>dG", function() require("dapui").open({ reset = true }) end, desc = "DAP: Reset DAP GUI layout size" },
      },
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      end,
      opts = {
        controls = {
          element = "repl",
          enabled = true,
          icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = "",
          },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = "single",
          mappings = { close = { "q", "<Esc>" } },
        },
        force_buffers = true,
        icons = { collapsed = "", current_frame = "", expanded = "" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.61 },
              { id = "breakpoints", size = 0.13 },
              { id = "stacks", size = 0.13 },
              { id = "repl", size = 0.13 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "watches", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
        mappings = {
          edit = "e",
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t",
        },
        render = {
          indent = 1,
          max_value_lines = 100,
        },
        open = { reset = true },
      },
    },
  },
  --- Database
  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = false,
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    -- stylua: ignore
    keys = {
      { "<leader>td", "<Cmd>DBUIToggle<CR>", desc = "vim-dadbod-ui: Toggle UI" },
    },
    init = function() vim.g.db_ui_use_nerd_fonts = 1 end,
    dependencies = {
      { "tpope/vim-dadbod" },
      {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = { "nvim-cmp" },
        ft = { "sql", "mysql", "plsql" },
        config = function(_, opts)
          require("cmp").setup.filetype({ "sql", "mysql", "plsql" }, {
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
            },
          })
        end,
      },
    },
  },
  --- Test manager
  {
    "nvim-neotest/neotest",
    enabled = false,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adapters
      "nvim-neotest/neotest-python",
    },
    -- stylua: ignore
    keys = {
      { "<leader>rtf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "neotest: Run all test in the current file" },
      { "<leader>rtd", function() require("neotest").run.run({strategy = "dap"}) end, desc = "neotest: Debug nearest test" },
      { "<leader>rtt", function() require("neotest").run.run() end, desc = "neotest: Run nearest test" },
      { "<leader>rtS", function() require("neotest").run.stop() end, desc = "neotest: Stop the nearest test" },
      { "<leader>rto", function() require("neotest").output_panel.toggle() end, desc = "neotest: Toggle output panel" },
      { "<leader>rtO", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "neotest: Show test output" },
      { "<leader>rtp", function() require("neotest").summary.toggle() end, desc = "neotest: Toggle summary panel" },
    },
    opts = {
      status = { virtual_text = true },
      output = { open_on_run = true },
    },
    config = function(_, opts)
      opts.adapters = { require("neotest-python") }
      require("neotest").setup(opts)
    end,
  },
  {
    "polirritmico/nvim-test",
    dev = false,
    cmd = {
      "TestSuite",
      "TestFile",
      "TestNearest",
      "TestLast",
      "TestVisit",
      "TestInfo",
    },
    opts = {
      termOpts = {
        direction = "float", -- vertical, horizontal, float
        float_position = "bottom",
        height = 24,
        width = 200,
        stopinsert = false,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>rtf", "<Cmd>silent TestFile<CR>", desc = "nvim-test: Run all test in the current file or run the last file tests." },
      { "<leader>rta", "<Cmd>silent TestSuite<CR>", desc = "nvim-test: Run the whole test suite following the current file or the last run test." },
      { "<leader>rtu", "<Cmd>silent TestNearest<CR>", desc = "nvim-test: Run the test nearest to the cursor or run the last test." },
      { "<leader>rtl", "<Cmd>silent TestLast<CR>", desc = "nvim-test: Run the last test." },
      { "<leader>glt", "<Cmd>silent TestVisit<CR>", desc = "nvim-test: Go/Open to the last test file that has ben run." },
      { "<leader>rtI", "<Cmd>silent TestInfo<CR>", desc = "nvim-test: Show info about the plugin" },
    },
  },
  --- Function stats (like references)
  {
    "VidocqH/lsp-lens.nvim",
    cond = false,
    event = "VeryLazy",
    opts = {
      sections = {
        git_authors = false,
      },
    },
  },
  --- Neovim Development
  --- Lsp helpers like types for lua and neovim plugin development
  {
    "folke/lazydev.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "Bilal2453/luvit-meta",
      { "LuaCATS/luassert" },
      { "LuaCATS/busted" },
    },
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "luassert/library", words = { "assert" } },
        { path = "busted/library", words = { "describe" } },
      },
    },
  },
  --- Profiler
  {
    "stevearc/profile.nvim",
    enabled = Workstation,
    cond = false,
    priority = 1500,
    lazy = false,
    -- Use utils.plugins.toggle_profile() to begin/end the profiler
  },
  --- Show highlights applied to variables names and virtual text marks
  {
    "echasnovski/mini.hipatterns",
    enabled = Workstation,
    cond = vim.uv.cwd():match("monokai%-nightasty") ~= nil,
    event = "VeryLazy",
    opts = {},
  },
}
