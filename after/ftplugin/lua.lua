vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "r" - "o"

-- Fix gf
-- From: https://stackoverflow.com/questions/73576802/neovim-gf-unable-to-find-file-in-path
vim.opt_local.include = [[\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+]]
vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
  vim.opt_local.path:append(path .. "/lua")
end
vim.opt_local.suffixesadd:prepend(".lua")

vim.keymap.set("n", "<leader>rr", "<Plug>PlenaryTestFile")
