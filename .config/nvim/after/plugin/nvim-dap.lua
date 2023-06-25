-- DAP
local plugin_name = "nvim-dap-ui"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Se necesita instalr debugpy con :Mason primero
require("dapui").setup({})
local dap_python = "$XDG_DATA_HOME/nvim/mason/packages/debugpy/venv/bin/python"
require("dap-python").setup(dap_python)

-- Mappings
local function map(mode, key, command)
	vim.keymap.set(mode, key, command, {silent = true})
end

map({"n", "v"}, "<F5>", "<Cmd>lua require'dap'.continue()<CR>")
map({"n", "v"}, "<F6>", "<Cmd>lua require'dap'.pause()<CR>")
map({"n", "v"}, "<F9>", "<Cmd>lua require'dap'.step_over()<CR>")
map({"n", "v"}, "<F8>", "<Cmd>lua require'dap'.step_into()<CR>")
map({"n", "v"}, "<F7>", "<Cmd>lua require'dap'.step_out()<CR>")
map({"n", "v"}, "<F12>", "<Cmd>lua require'dap'.close()<CR>")
map({"n", "v"}, "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>")
map({"n", "v"}, "<Leader>do", "<Cmd>lua require'dap'.repl.open()<CR>")
map({"n", "v"}, "<Leader>dr", "<Cmd>lua require'dap'.run_last()<CR>")
map({"n", "v"}, "<Leader>dg", "<Cmd>lua require'dapui'.toggle()<CR>")
map({"n", "v"}, "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(" ..
                             "vim.fn.input('Breakpoint condition: '))<CR>")
map({"n", "v"}, "<Leader>dl", "<Cmd>lua require'dap'.set_breakpoint(nil, " ..
                              "nil, vim.fn.input('Log point message: '))<CR>")

