--- DAP: Debugger connector

return {
    "mfussenegger/nvim-dap",
    version = "*",
    dependencies = {
        {"rcarriga/nvim-dap-ui"},
        {"mfussenegger/nvim-dap-python"},
        {"williamboman/mason.nvim"},
        {"WhoIsSethDaniel/mason-tool-installer.nvim"},
    },
    config = function()
        local debugpy = require("mason-registry").get_package("debugpy")
        local python_path = debugpy:get_install_path() .. "/venv/bin/"
        require("dap-python").setup(python_path .. "python")
        require("dap-python").test_runner = "pytest"
    end,
    keys = function()
        local dap = require("dap")
        return {
            { "<F5>", dap.continue, mode = { "n", "v" }, desc = "DAP: Continue execution", silent = true },
            { "<F6>", dap.pause, mode = { "n", "v" }, desc = "DAP: Pause execution", silent = true },
            { "<F7>", dap.step_out, mode = { "n", "v" }, desc = "DAP: Step out", silent = true },
            { "<F8>", dap.step_into, mode = { "n", "v" }, desc = "DAP: Step into", silent = true },
            { "<F9>", dap.step_over, mode = { "n", "v" }, desc = "DAP: Step over", silent = true },
            { "<F12>", dap.close, mode = { "n", "v" }, desc = "DAP: Close execution", silent = true },
            { "<Leader>b", dap.toggle_breakpoint, mode = { "n", "v" }, desc = "DAP: Add/remove breakpoint into the current line", silent = true },
            { "<Leader>dc", dap.repl.open, mode = { "n", "v" }, desc = "DAP: Open debug console", silent = true },
            { "<Leader>dr", dap.run_last, mode = { "n", "v" }, desc = "DAP: Rerun last debug adapter/config", silent = true },
            { "<Leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, mode = { "n", "v" }, desc = "DAP: Add a conditional breakpoint", silent = true },
            { "<Leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, mode = { "n", "v" }, desc = "DAP: Add a logpoint into the current line", silent = true },
        }
    end,
}
