-- Undo Tree
local plugin_name = "undotree"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Cambia el foco al abrir el panel
vim.g.undotree_SetFocusWhenToggle = 1

-- Abrir/cerrar el panel
Keymap("n", "<leader>u", vim.cmd.UndotreeToggle, "UndoTree: Abrir/cerrar el panel")
