--- GUI for DAP

return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        -- "mfussenegger/nvim-dap"
        "nvim-dap"
    },
    lazy = true,
    ft = "python",
    keys = function()
        local dapui = require("dapui")
        return {
            { "<Leader>di", dapui.eval, mode = { "n", "v" }, desc = "DAP: Show debug info of the element under the cursor", silent = true },
            { "<Leader>dg", dapui.toggle, mode = { "n", "v" }, desc = "DAP: Toggle DAP GUI", silent = true },
            { "<Leader>dt", function() require("dap-python").test_method() end, mode = { "n", "v" }, desc = "DAP: Run test method", silent = true },
            -- FIX: Reset UI size after running vim-test call
            { "<Leader>dG", function() dapui.open({reset=true}) end, mode = { "n", "v" }, desc = "DAP: Reset DAP GUI layout size", silent = true },
        }
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
    },
}
