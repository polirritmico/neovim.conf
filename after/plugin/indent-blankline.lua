-- indent-blankline
if not Check_loaded_plugin("indent-blankline.nvim") then return end

require("ibl").setup({
    indent = {
        char = {"│"},
        smart_indent_cap = false,
    },
    scope = { enabled = false },
})
