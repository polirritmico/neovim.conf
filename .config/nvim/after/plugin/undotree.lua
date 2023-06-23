-- Undo Tree
local plugin_name = "telescope.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end


vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
