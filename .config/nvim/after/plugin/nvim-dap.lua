-- DAP
local plugin_name = "nvim-dap-ui"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Config
local my_config = {
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
        terminate = ""
      }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      collapsed = "",
      current_frame = "",
      expanded = ""
    },
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.75
          }, {
            id = "breakpoints",
            size = 0.10
          }, {
            id = "stacks",
            size = 0.10
          }, {
            id = "watches",
            size = 0.05
          } },
        position = "left",
        size = 27
      }, {
        elements = { {
            id = "repl",
            size = 0.3
          }, {
            id = "console",
            size = 0.7
          } },
        position = "bottom",
        size = 10
      } },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  }


-- Se necesita instalar debugpy con :Mason primero
require("dapui").setup(my_config)
local dap_python = "$XDG_DATA_HOME/nvim/mason/packages/debugpy/venv/bin/python"
require("dap-python").setup(dap_python)


-- Mappings
local function map(mode, key, command)
    vim.keymap.set(mode, key, command, { silent = true })
end

map({ "n", "v" }, "<F5>", "<Cmd>lua require'dap'.continue()<CR>")
map({ "n", "v" }, "<F6>", "<Cmd>lua require'dap'.pause()<CR>")
map({ "n", "v" }, "<F7>", "<Cmd>lua require'dap'.step_out()<CR>")
map({ "n", "v" }, "<F8>", "<Cmd>lua require'dap'.step_into()<CR>")
map({ "n", "v" }, "<F9>", "<Cmd>lua require'dap'.step_over()<CR>")
map({ "n", "v" }, "<F12>", "<Cmd>lua require'dap'.close()<CR>")
map({ "n", "v" }, "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>")
map({ "n", "v" }, "<Leader>do", "<Cmd>lua require'dap'.repl.open()<CR>")
map({ "n", "v" }, "<Leader>dr", "<Cmd>lua require'dap'.run_last()<CR>")
map({ "n", "v" }, "<Leader>dg", "<Cmd>lua require'dapui'.toggle()<CR>")
map({ "n", "v" }, "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(" ..
    "vim.fn.input('Breakpoint condition: '))<CR>")
map({ "n", "v" }, "<Leader>dl", "<Cmd>lua require'dap'.set_breakpoint(nil, " ..
    "nil, vim.fn.input('Log point message: '))<CR>")
-- Show debug info of the element under the cursor
map({ "n", "v" }, "<Leader>di", "<Cmd>lua require('dapui').eval()<CR>")
