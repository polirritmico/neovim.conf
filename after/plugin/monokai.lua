-- Monokai Nvim Theme
local plugin_name = "monokai.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Color de mensajes warning de LSP
--vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ff9700" })

-- Resaltado de la línea actual
vim.opt.cursorline = true

require("monokai").setup({
    -- Fondo transparente global y texto blanco
    transparent = true,
    lualine_bold = true,
    styles = {
        keywords = { italic = false },
    },
})

-- Cargar el tema
vim.cmd("colorscheme monokai")
