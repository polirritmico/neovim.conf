-- DAP
if not Check_loaded_plugin("nvim-dap-ui") then return end

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
            terminate = "",
        }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
        border = "single",
        mappings = {close = { "q", "<Esc>" }}
    },
    force_buffers = true,
    icons = {collapsed = "", current_frame = "", expanded = ""},
    layouts = {
        {
            elements = {
                {id = "scopes", size = 0.61},
                {id = "breakpoints", size = 0.13},
                {id = "stacks", size = 0.13},
                {id = "repl", size = 0.13}
            },
            position = "left",
            size = 50
        }, {
            elements = {
                {id = "watches", size = 0.5},
                {id = "console", size = 0.5}
            },
            position = "bottom",
            size = 10
        }
    },
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
    },
    open = { reset = true },
}

local dap = require("dap")
local dapui = require("dapui")
dapui.setup(my_config)

-- Python: Se necesita instalar debugpy con ':Mason debugpy'
if require("mason-registry").is_installed("debugpy") then
    local dap_python = "$XDG_DATA_HOME/nvim/mason/packages/debugpy/venv/bin/python"
    require("dap-python").setup(dap_python)
    require("dap-python").test_runner = "pytest"
end

-- Mappings
Keymap({ "n", "v" }, "<F5>", dap.continue, "DAP: Continue execution")
Keymap({ "n", "v" }, "<F6>", dap.pause, "DAP: Pause execution")
Keymap({ "n", "v" }, "<F7>", dap.step_out, "DAP: Step out")
Keymap({ "n", "v" }, "<F8>", dap.step_into, "DAP: Step into")
Keymap({ "n", "v" }, "<F9>", dap.step_over, "DAP: Step over")
Keymap({ "n", "v" }, "<F12>", dap.close, "DAP: Close execution")
Keymap({ "n", "v" }, "<Leader>b", dap.toggle_breakpoint, "DAP: Add/remove breakpoint into the current line")
Keymap({ "n", "v" }, "<Leader>dc", dap.repl.open, "DAP: Open debug console")
Keymap({ "n", "v" }, "<Leader>dr", dap.run_last, "DAP: Rerun last debug adapter/config")
Keymap({ "n", "v" }, "<Leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, "DAP: Add a conditional breakpoint")
Keymap({ "n", "v" }, "<Leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, "DAP: Add a logpoint into the current line")

Keymap({ "n", "v" }, "<Leader>di", dapui.eval, "DAP: Show debug info of the element under the cursor")
Keymap({ "n", "v" }, "<Leader>dg", dapui.toggle, "DAP: Toggle DAP GUI")
Keymap({ "n", "v" }, "<Leader>dt", function() require("dap-python").test_method() end, "DAP: Run test method")
-- FIX: Reset UI size after running vim-test call
Keymap({ "n", "v" }, "<Leader>dG", function() dapui.open({reset=true}) end, "DAP: Reset DAP GUI layout size")
