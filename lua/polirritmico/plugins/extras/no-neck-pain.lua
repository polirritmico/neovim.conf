--- Center buffer on screen

return {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    enabled = true,
    cmd = "NoNeckPain",
    opts = {
        autocmds = {
            reloadOnColorSchemeChange = true,
        },
        buffers = {
            bo = { filetype = "md" },
            right = { enabled = false },
            wo = { fillchars = "eob: " }, -- Hide ~ from spacebuffers
        },
        width = 100,
    },
    keys = function()
        NoNeckPain_default_border_hl = {}
        NoNeckPainToggleState = false

        local function NNP_toggle_with_custom_border_hl()
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

        return {{
            "<leader>tc", NNP_toggle_with_custom_border_hl,
            {"n", "s"}, desc = "NoNeckPain: Toggle center mode", silent = true
        }}
    end,
}
