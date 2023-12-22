--- Center buffer on screen

-- NoNeckPain_default_border_hl = {}
-- NoNeckPainToggleState = false
--
-- local function NNP_toggle_with_custom_border_hl()
--     local border_name = "WinSeparator"
--     local custom_hl = { fg = 4079166 } -- "#3e3e3e" in dec
-- end

return {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    config = function()
        require("no-neck-pain").setup({
            width = 100,
            buffers = {
                bo = { filetype = "md" },
                right = { enabled = false },
                wo = { fillchars = "eob: " }, -- Hide ~ from spacebuffers
            },
        })

    end
}
