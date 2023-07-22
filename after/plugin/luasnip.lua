-- Snippets
local plugin_name = "LuaSnip"
if not Check_loaded_plugin(plugin_name) then
    return
end

local ls = require("luasnip")
-- local types = require("luasnip.util.types")

require("luasnip.loaders.from_vscode").lazy_load()
local my_snippets_path = "~/.config/nvim/lua/polirritmico/snippets/"
require("luasnip.loaders.from_lua").load({ paths = my_snippets_path })

ls.config.set_config {
    history = false,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = false,
}

-- Teclas
local silent = {silent = true}
local exp_silent = {expr = true, silent = true}
vim.keymap.set({"i", "s"}, "<c-j>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, silent)
vim.keymap.set({ "i", "s" }, "<c-f>", function()
    if ls.jumpable(1) then
        ls.jump(1)
    end
end, silent)
vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, silent)
vim.keymap.set({"i", "s"}, "<c-l>", function()
    if ls.choice_active() then
        return "<Plug>luasnip-next-choice"
    end
end, exp_silent)
vim.keymap.set({"i", "s"}, "<c-h>", function()
    if ls.choice_active() then
        return "<Plug>luasnip-prev-choice"
    end
end, exp_silent)
