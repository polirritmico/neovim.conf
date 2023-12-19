-- Undo Tree
if not Check_loaded_plugin("undotree") then return end

-- Change focus when opening pannel
vim.g.undotree_SetFocusWhenToggle = 1

-- Panel toggle
Keymap("n", "<leader>tu", vim.cmd.UndotreeToggle, "UndoTree: Open/Close panel.")
