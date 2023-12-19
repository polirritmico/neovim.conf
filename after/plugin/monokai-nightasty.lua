-- Monokai NighTasty Theme
if not Check_loaded_plugin("monokai-nightasty.nvim") then return end

-- Highlight line at the cursor position
vim.opt.cursorline = true

-- Default to dark theme
vim.o.background = "dark"

-- Change to light
local date_output = vim.api.nvim_exec2("!date +'\\%H\\%M'", {output = true})
local system_time = tonumber(string.match(date_output["output"], "%d%d%d%d"))
if system_time >= 1600 and system_time < 1930 then
    vim.o.background = "light"
end

require("monokai-nightasty").setup({
    dark_style_background = "transparent",
    light_style_background = "default",
    color_headers = false,
    lualine_bold = true,
    lualine_style = "default",
    -- hl_styles = { comments = { italic = false } },
})

-- Load the theme
vim.cmd("colorscheme monokai-nightasty")

-- mapping to toggle dark/light theme
Keymap({"n"}, "<leader>tt", "<CMD>MonokaiToggleLight<CR>", "Monokai-NighTasty: Toggle dark/light theme")
