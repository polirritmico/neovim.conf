-- Auto-pairs
local plugin_name = "virt-column.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Alternatives: │, |, ¦, ┆, ┊
require("virt-column").setup({ char = "┊" })

-- Change line color
vim.cmd("highlight! VirtColumn guifg='#2b2b2b'")

