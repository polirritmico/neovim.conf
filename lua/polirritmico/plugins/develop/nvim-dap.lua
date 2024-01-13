--- DAP: Debugger connector
return {
    {
        "mfussenegger/nvim-dap",
        version = "*",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        ft = { "python" },
        dependencies = {
            { "rcarriga/nvim-dap-ui" },
            { "mfussenegger/nvim-dap-python" },
            "mason.nvim",
        },
        config = function()
            local debugpy = require("mason-registry").get_package("debugpy")
            local python_path = debugpy:get_install_path() .. "/venv/bin/"
            require("dap-python").setup(python_path .. "python")
            require("dap-python").test_runner = "pytest"
        end,
        keys = function()
            local dap = require("dap")
            -- stylua: ignore
            return {
                { "<F5>", dap.continue, mode = { "n", "v" }, desc = "DAP: Continue execution", silent = true },
                { "<F6>", dap.pause, mode = { "n", "v" }, desc = "DAP: Pause execution", silent = true },
                { "<F7>", dap.step_out, mode = { "n", "v" }, desc = "DAP: Step out", silent = true },
                { "<F8>", dap.step_into, mode = { "n", "v" }, desc = "DAP: Step into", silent = true },
                { "<F9>", dap.step_over, mode = { "n", "v" }, desc = "DAP: Step over", silent = true },
                { "<F12>", dap.close, mode = { "n", "v" }, desc = "DAP: Close execution", silent = true },
                { "<Leader>dc", dap.repl.open, mode = { "n", "v" }, desc = "DAP: Open debug console", silent = true },
                { "<Leader>dr", dap.run_last, mode = { "n", "v" }, desc = "DAP: Rerun last debug adapter/config", silent = true },
                { "<Leader>b", dap.toggle_breakpoint, mode = { "n", "v" },
                    desc = "DAP: Add/remove breakpoint into the current line", silent = true },
                { "<Leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
                    mode = { "n", "v" }, desc = "DAP: Add a conditional breakpoint", silent = true },
                { "<Leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
                    mode = { "n", "v" }, desc = "DAP: Add a logpoint into the current line", silent = true },
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-dap" },
        lazy = true,
        ft = "python",
        keys = function()
            local dapui = require("dapui")
            -- stylua: ignore
            return {
                { "<Leader>di", dapui.eval, mode = { "n", "v" }, desc = "DAP: Show debug info of the element under the cursor", silent = true },
                { "<Leader>dg", dapui.toggle, mode = { "n", "v" }, desc = "DAP: Toggle DAP GUI", silent = true },
                { "<Leader>rtd", function() require("dap-python").test_method() end, mode = { "n", "v" }, desc = "DAP: Run test method", silent = true },
                -- FIX: Reset UI size after running vim-test call
                { "<Leader>dG", function() dapui.open({ reset = true }) end, mode = { "n", "v" }, desc = "DAP: Reset DAP GUI layout size", silent = true },
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
