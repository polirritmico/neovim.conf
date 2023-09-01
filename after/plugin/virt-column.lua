-- Auto-pairs
if not Check_loaded_plugin("virt-column.nvim") then return end

require("virt-column").setup({ char = "┊" }) -- Custom char
