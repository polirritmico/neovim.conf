-- which-key.nvim
if not Check_loaded_plugin("which-key.nvim") then return end

vim.o.timeout = true
vim.o.timeoutlen = 1000

require("which-key").setup({
    popup_mappings = {
        scroll_down = "<c-n>",
        scroll_up = "<c-p>",
    },
    window = {border = "single"}
})
