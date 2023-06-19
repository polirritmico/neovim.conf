-- Fugitive
if type(packer_plugins) ~= "table" or packer_plugins["telescope.nvim"] == nil then
	return
end

vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
