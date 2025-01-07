local utils = require("utils")

return {
  {
    "polirritmico/manual-tag-closer.nvim",
    cond = false,
    dev = true,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {},
  },
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
      -- stylua: ignore
      config = function()
        local dap = require("dap")
        utils.plugins.dap_config_typescript(dap)

        local dapui = require("dapui")
        dap.listeners.before.attach.dapui_config = function() dapui.open() end
      end,
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
          -- stylua: ignore
          keys = {
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
        require("dapui").setup(opts)
        utils.plugins.dap_set_custom_marks()
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
  --- Test manager
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adapters
      "nvim-neotest/neotest-python",
      "MisanthropicBit/neotest-busted",
    },
    -- stylua: ignore
    keys = {
      { "<leader>rtf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "neotest: Run all test in the current file" },
      { "<leader>rtd", function() require("neotest").run.run({strategy = "dap"}) end, desc = "neotest: Debug nearest test" },
      { "<leader>rtl", function() require("neotest").run.run_last() end, desc = "neotest: Re-run last test" },
      { "<leader>rtL", function() require("neotest").run.run_last({ strategy = "dap" }) end, desc = "neotest: Debug last test" },
      { "<leader>rtt", function() require("neotest").run.run() end, desc = "neotest: Run nearest test" },
      { "<leader>rtS", function() require("neotest").run.stop() end, desc = "neotest: Stop the nearest test" },
      { "<leader>rto", function() require("neotest").output_panel.toggle() end, desc = "neotest: Toggle output panel" },
      { "<leader>rtO", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "neotest: Show test output" },
      { "<leader>rtp", function() require("neotest").summary.toggle() end, desc = "neotest: Toggle summary panel" },
      { "<leader>rtc", function() require("neotest").output_panel.clear() end, desc = "neotest: Clean the output panel" },
    },
    opts = {
      log_level = vim.log.levels.OFF, -- default: WARN
      output = { open_on_run = true },
      summary = { open = "topleft vsplit | vertical resize 45" }, -- right: botright
      status = { virtual_text = true },
      busted = {
        busted_command = ".tests/data/nvim/lazy/busted/bin/busted",
        minimal_init = "tests/busted.lua",
        local_luarocks_only = true,
      },
      python = {
        dap = { justMyCode = true },
        runner = "pytest",
      },
    },
    config = function(_, opts)
      opts.adapters = {
        require("neotest-python")(opts.python),
        require("neotest-busted")(opts.busted),
      }
      require("neotest").setup(opts)
    end,
  },
  --- Git integration
  {
    "echasnovski/mini.diff",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { "<leader>td", function() require("mini.diff").toggle_overlay() end, desc = "Mini.diff: Toggle diff overlay", },
    },
    opts = { style = "number" },
  },
  --- Neovim Development
  --- Lsp helpers like types for lua and neovim plugin development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "${3rd}/luassert/library", words = { "assert" } },
        { path = "${3rd}/busted/library", words = { "describe" } },
      },
    },
  },
  --- Profiler. Check the utils.profiler module for helper functions
  {
    "stevearc/profile.nvim",
    enabled = Workstation,
    cond = false,
    priority = 1500,
    lazy = false,
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
