-- No neck pain
if not Check_loaded_plugin("no-neck-pain.nvim") then return end

require("no-neck-pain").setup({
    width = 100,
    buffers = {
        bo = { filetype = "md" },
        right = { enabled = false },
        wo = { fillchars = "eob: " }, -- Hide ~ from spacebuffers
    },
})

NoNeckPain_default_border_hl = {}
NoNeckPainToggleState = false

local NNP_toggle_with_custom_border_hl = function()
    local border_name = "WinSeparator"
    local custom_hl = { fg = 4079166 } -- "#3e3e3e" in dec

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

Keymap({"n", "s"}, "<leader>tc", NNP_toggle_with_custom_border_hl, "NoNeckPain: Toggle center mode")
