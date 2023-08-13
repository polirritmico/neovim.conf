-- No neck pain
if not Check_loaded_plugin("no-neck-pain.nvim") then return end

require("no-neck-pain").setup({
    buffers = {
        wo = { fillchars = "eob: " }, -- Hide ~ from spacebuffers
        bo = { filetype = "md" },
        scratchPad = {
            enabled = true,
            location = "~/.local/share/nvim/",
        }
    },
})

