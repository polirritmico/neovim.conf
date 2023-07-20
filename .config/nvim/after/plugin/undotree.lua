-- Undo Tree
local plugin_name = "undotree"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Cambia el foco al abrir el panel
vim.g.undotree_SetFocusWhenToggle = 1

-- Abrir/cerrar el panel
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, {silent = true})
