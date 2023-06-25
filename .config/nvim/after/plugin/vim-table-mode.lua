-- vim-table-mode
local plugin_name = "vim-table-mode"
if not Check_loaded_plugin(plugin_name) then
    return
end

vim.g.table_mode_corner = "|"
--vim.g.table_mode_corner_corner = "+"
--vim.g.table_mode_header_fillchar = "="
