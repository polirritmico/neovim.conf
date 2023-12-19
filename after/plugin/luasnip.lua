-- Snippets
if not Check_loaded_plugin("LuaSnip") then return end

local ls = require("luasnip")
local types = require("luasnip.util.types")

require("luasnip.loaders.from_vscode").lazy_load()
local my_snippets_path = "~/.config/nvim/lua/polirritmico/snippets/"
require("luasnip.loaders.from_lua").load({ paths = my_snippets_path })

ls.setup({
    history = false,
    update_events = "TextChanged,TextChangedI",
    enable_autosnippets = false,
    -- Cancel snippet session when leaving insert mode :h luasnip-config-options
    region_check_events = "CursorMoved",
    delete_check_events = "TextChanged,InsertLeave",
    -- Add virtual marks on inputs
    ext_opts = {
        [types.choiceNode] = {
            active = { virt_text = { { "← Choice", "Conceal" } }, },
            pasive = { virt_text = { { "← Choice", "Comment" } }, },
        },
        [types.insertNode] = {
            active = { virt_text = { { "← Insert", "Conceal" } }, },
            pasive = { virt_text = { { "← Insert", "Comment" } }, },
        },
    },
})

--- Keys
vim.keymap.set({"i", "s"}, "<c-j>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, {silent = true, desc = "LuaSnip: Expand snippet or jump to the next input index"})

vim.keymap.set({ "i", "s" }, "<c-f>", function()
    if ls.jumpable(1) then
        ls.jump(1)
    end
end, {silent = true, desc = "LuaSnip: Jump to the next input index"})

vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, {silent = true, desc = "LuaSnip: Jump to the previous input index"})

vim.keymap.set({"i", "s"}, "<c-l>", function()
    if ls.choice_active() then
        return "<Plug>luasnip-next-choice"
    end
end, {expr = true, silent = true, desc = "LuaSnip: Cycle to the next choice in the snippet"})

vim.keymap.set({"i", "s"}, "<c-h>", function()
    if ls.choice_active() then
        return "<Plug>luasnip-prev-choice"
    end
end, {expr = true, silent = true, desc = "LuaSnip: Cycle to the previous choice in the snippet"})
