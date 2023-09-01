-- Undo Tree
if not Check_loaded_plugin("undotree") then return end

-- Cambia el foco al abrir el panel
vim.g.undotree_SetFocusWhenToggle = 1

-- Abrir/cerrar el panel
Keymap("n", "<leader>u", vim.cmd.UndotreeToggle, "UndoTree: Abrir/cerrar el panel")
