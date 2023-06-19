-- vim-table-mode 
if type(packer_plugins) ~= "table" or packer_plugins["vim-table-mode"] == nil then
	return
end

vim.g.table_mode_corner = "|"
--vim.g.table_mode_corner_corner = "+"
--vim.g.table_mode_header_fillchar = "="
