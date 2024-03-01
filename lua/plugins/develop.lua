--- DAP: Debugger connector
return {
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
          -- NOTE: Instructions
          -- 1. launch the server in the debuggee nvim whit <F10>
          -- 2. launch second instance with the code and dap
          -- 3. place breakpoint <leader>b
          -- 4. Connect to the debuggee with <F5> (code instance)
          -- 5. Run the code from the debuggee
          "jbyuki/one-small-step-for-vimkind",
          lazy = true,
          config = function()
            local dap = require("dap")
            dap.configurations.lua = {
              {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
              },
            }

            dap.adapters.nlua = function(callback, config)
              callback({
                type = "server",
                host = config.host or "127.0.0.1",
                port = config.port or 8086,
              })
            end
          end,
          keys = {
            -- stylua: ignore
            { "<F10>", function() require("osv").launch({port = 8086}) end, mode = { "n", "v" }, ft = "lua", desc = "OSV: Launch Server." },
          },
        },
        -- {
        --   "jbyuki/one-small-step-for-vimkind",
        --   config = function()
        --     local dap = require("dap")
        --     dap.adapters.nlua = function(callback, conf)
        --       local adapter = {
        --         type = "server",
        --         host = conf.host or "127.0.0.1",
        --         port = conf.port or 8086,
        --       }
        --       if conf.start_neovim then
        --         local dap_run = dap.run
        --         dap.run = function(c)
        --           adapter.port = c.port
        --           adapter.host = c.host
        --         end
        --         require("osv").run_this()
        --         dap.run = dap_run
        --       end
        --       callback(adapter)
        --     end
        --     dap.configurations.lua = {
        --       {
        --         type = "nlua",
        --         request = "attach",
        --         name = "Run this file",
        --         start_neovim = {},
        --       },
        --       {
        --         type = "nlua",
        --         request = "attach",
        --         name = "Attach to running Neovim instance (port = 8086)",
        --         port = 8086,
        --       },
        --     }
        --   end,
        --   keys = {
        --     {
        --       "<leader>rl",
        --       function()
        --         require("osv").launch({ port = 8086 })
        --       end,
        --       ft = "lua",
        --       desc = "Dap: Launch Lua adapter.",
        --     },
        --   },
        -- },
      },
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = "nvim-dap",
      -- stylua: ignore
      keys = {
        { "<Leader>di", function() require("dapui").eval() end, desc = "DAP: Show debug info of the element under the cursor" },
        { "<Leader>dg", function() require("dapui").toggle({}) end, desc = "DAP: Toggle DAP GUI" },
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
            size = 50,
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
      { "<leader>rtf", "<Cmd>silent TestFile<CR>", desc = "nvim-test: Runs all test in the current file or runs the last file tests." },
      { "<leader>rta", "<Cmd>silent TestSuite<CR>", desc = "nvim-test: Run the whole test suite following the current file or the last run test." },
      { "<leader>rtu", "<Cmd>silent TestNearest<CR>", desc = "nvim-test: Run the test nearest to the cursor or run the last test." },
      { "<leader>rtl", "<Cmd>silent TestLast<CR>", desc = "nvim-test: Runs the last test." },
      { "<leader>glt", "<Cmd>silent TestVisit<CR>", desc = "nvim-test: Go/Open to the last test file that has ben run." },
      { "<leader>rtI", "<Cmd>silent TestInfo<CR>", desc = "nvim-test: Show info about the plugin" },
    },
  },
  --- Session Manager
  {
    "rmagatti/auto-session",
    enabled = false,
    dir = "/home/eduardo/Informática/Patches/auto-session",
    event = "VeryLazy",
    opts = {
      auto_session_suppress_dirs = {
        vim.fn.expand("$HOME/"),
        vim.fn.expand("$XDG_DOWNLOAD_DIR"),
        "/",
      },
    },
  },
}
