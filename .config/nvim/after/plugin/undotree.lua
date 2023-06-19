-- Undo Tree
if type(packer_plugins) ~= "table" or packer_plugins["telescope.nvim"] == nil then
	return
end

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
