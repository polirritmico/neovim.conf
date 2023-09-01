-- Monokai NighTasty Theme
if not Check_loaded_plugin("monokai-nightasty.nvim") then return end

-- Highlight line at the cursor position
vim.opt.cursorline = true

-- Default to dark theme
vim.o.background = "dark"

require("monokai-nightasty").setup({
    dark_style_background = "transparent",
    light_style_background = "default",
    color_headers = false,
    lualine_bold = true,
    lualine_style = "default",
})

-- Load the theme
vim.cmd("colorscheme monokai-nightasty")

-- mapping to toggle dark/light theme
Keymap({"n"}, "<leader>tt", "<CMD>:MonokaiToggleLight<CR>", "Monokai-NighTasty: Toggle dark/light theme")
