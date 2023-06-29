-- Snippets
local plugin_name = "LuaSnip"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Lua: ../../lua/polirritmico/snippets/lua.lua
-- Python: ../../lua/polirritmico/snippets/python.lua
-- Bash: ../../lua/polirritmico/snippets/sh.lua

local ls = require("luasnip")
local types = require("luasnip.util.types")

require("luasnip.loaders.from_vscode").lazy_load()
local my_snippets_path = "~/.config/nvim/lua/polirritmico/snippets/"
require("luasnip.loaders.from_lua").load({ paths = my_snippets_path })

ls.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    --ext_opts = {
    --    [types.choiceNode] = {
    --        active = {
    --            virt_text = {
    --                { "← Current choice", "Error" },
    --                --{ "●", "GruvboxOrange" },
    --            },
    --        },
    --    },
    --},
}

-- Teclas
vim.keymap.set({"i", "s"}, "<c-j>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, {silent = true})

vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.jumpable(1) then
        ls.jump(-1)
    end
end, {silent = true })

vim.keymap.set("i", "<c-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

-- Reimportar los snippets
vim.keymap.set("n", "<leader><leader>s", "<cmd>source "..MyPluginConfigPath.."luasnip.lua<CR>")

