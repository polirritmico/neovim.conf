-- No neck pain
if not Check_loaded_plugin("no-neck-pain.nvim") then return end

require("no-neck-pain").setup({
    width = 100,
    buffers = {
        bo = { filetype = "md" },
        wo = { fillchars = "eob: " }, -- Hide ~ from spacebuffers
        scratchPad = {
            enabled = true,
            location = "~/.local/share/nvim/",
        }
    },
})

NoNeckPain_default_border_hl = {}
NoNeckPainToggleState = false

local custom_toggle_border_hl = function()
    local border_name = "WinSeparator"
    local custom_hl = { fg = 4079166 }
    -- local current_hl = vim.api.nvim_get_hl(0, { name = border_name })

    if NoNeckPain_default_border_hl.fg == nil then
        NoNeckPain_default_border_hl = vim.api.nvim_get_hl(
            0, { name = border_name, link = true }
        )
    end

    if NoNeckPainToggleState then
        vim.api.nvim_set_hl(0, border_name, NoNeckPain_default_border_hl)
    else
        vim.api.nvim_set_hl(0, border_name, custom_hl)
    end
    NoNeckPainToggleState = not NoNeckPainToggleState

    vim.cmd([[NoNeckPain]])
end

Keymap({"n", "s"}, "<leader>tc", custom_toggle_border_hl, "NoNeckPain: Toggle center mode")
-- Keymap({"n", "s"}, "<leader>tc", "<CMD>NoNeckPain<CR>", "NoNeckPain: Toggle center mode")
