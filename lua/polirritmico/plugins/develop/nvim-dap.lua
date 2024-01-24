--- DAP: Debugger connector
return {
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
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
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
}
