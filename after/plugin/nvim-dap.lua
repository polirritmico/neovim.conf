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
            size = 30
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
    }
}


-- Python: Se necesita instalar debugpy con ':Mason debugpy'
if require("mason-registry").is_installed("debugpy") then
    require("dapui").setup(my_config)
    local dap_python = "$XDG_DATA_HOME/nvim/mason/packages/debugpy/venv/bin/python"
    require("dap-python").setup(dap_python)
end

-- Mappings
Keymap({ "n", "v" }, "<F5>", "<Cmd>lua require'dap'.continue()<CR>", "DAP: Continue execution")
Keymap({ "n", "v" }, "<F6>", "<Cmd>lua require'dap'.pause()<CR>", "DAP: Pause execution")
Keymap({ "n", "v" }, "<F7>", "<Cmd>lua require'dap'.step_out()<CR>", "DAP: Step out")
Keymap({ "n", "v" }, "<F8>", "<Cmd>lua require'dap'.step_into()<CR>", "DAP: Step into")
Keymap({ "n", "v" }, "<F9>", "<Cmd>lua require'dap'.step_over()<CR>", "DAP: Step over")
Keymap({ "n", "v" }, "<F12>", "<Cmd>lua require'dap'.close()<CR>", "DAP: Close execution")
Keymap({ "n", "v" }, "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", "DAP: Add/remove breakpoint into the current line")
Keymap({ "n", "v" }, "<Leader>dc", "<Cmd>lua require'dap'.repl.open()<CR>", "DAP: Open debug console")
Keymap({ "n", "v" }, "<Leader>dr", "<Cmd>lua require'dap'.run_last()<CR>", "DAP: Rerun last debug adapter/config")
Keymap({ "n", "v" }, "<Leader>dg", "<Cmd>lua require'dapui'.toggle()<CR>", "DAP: Toggle DAP GUI")
Keymap({ "n", "v" }, "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(" ..
    "vim.fn.input('Breakpoint condition: '))<CR>", "DAP: Add a conditional breakpoint")
Keymap({ "n", "v" }, "<Leader>dl", "<Cmd>lua require'dap'.set_breakpoint(nil, " ..
    "nil, vim.fn.input('Log point message: '))<CR>", "DAP: Add a logpoint into the current line")
Keymap({ "n", "v" }, "<Leader>di", "<Cmd>lua require('dapui').eval()<CR>", "DAP: Show debug info of the element under the cursor")
