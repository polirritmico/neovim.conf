-- DAP Debugger

-- Register the adapters and configurations
require("dapui").setup()
require('dap-python').setup('~/.local/share/nvim/debugpy/bin/python')

local function map(m, k, v)
	vim.keymap.set(m, k, v, { silent = true })
end

--map({"n", "v"}, "<>", "require'dap'.()<CR>")
map({"n", "v"}, "<F5>", "<Cmd>lua require'dap'.continue()<CR>")
map({"n", "v"}, "<F3>", "<Cmd>lua require'dap'.step_over()<CR>")
map({"n", "v"}, "<F2>", "<Cmd>lua require'dap'.step_into()<CR>")
map({"n", "v"}, "<F12>", "<Cmd>lua require'dap'.step_out()<CR>")
--nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
map({"n", "v"}, "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>")
map({"n", "v"}, "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
--nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
map({"n", "v"}, "<Leader>dl", "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
--nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
map({"n", "v"}, "<Leader>do", "<Cmd>lua require'dap'.repl.open()<CR>")
--nnoremap <silent> <Leader>do <Cmd>lua require'dap'.repl.open()<CR>
map({"n", "v"}, "<Leader>dr", "<Cmd>lua require'dap'.run_last()<CR>")
--nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.run_last()<CR>
map({"n", "v"}, "<Leader>dg", "<Cmd>lua require'dapui'.toggle()<CR>")
--nnoremap <silent> <Leader>dg <Cmd>lua require'dapui'.toggle()<CR>
