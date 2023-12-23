-- Lazy plugin file ../core/cmp.lua
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

local M = {}

function M.setup()
    cmp.setup({
        formatting = {
            expandable_indicator = true, -- shows the ~ symbol when expandable
            -- Suggestions order :h formatting.fields
            fields = { "abbr", "menu", "kind" },
            format = function(entry, item)
                local short_name = {
                    nvim_lsp = "LSP",
                    nvim_lua = "nvim",
                }
                local menu_name = short_name[entry.source.name] or entry.source.name
                item.menu = string.format("[%s]", menu_name)
                return item
            end,
        },
        mapping = {
            ["<C-j>"] = cmp.mapping.confirm({
                behaviour = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<Up>"] = cmp.mapping.select_prev_item({ select = true }),
            ["<Down>"] = cmp.mapping.select_next_item({ select = true }),
            ["<C-n>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ select = true })
                elseif luasnip.choice_active() then
                    luasnip.change_choice(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        sources = {
            -- The order will be respected in the cmp menu
            { name = "luasnip", option = { use_show_condition = false } },
            { name = "path" },
            { name = "nvim_lsp" },
            { name = "cmp_luasnip" },
            { name = "buffer", keyword_lentgth = 3 },
        },
        -- Add border to popup window
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered()
        },
    })

    -- Insert "(" after select function or method item
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    -- Use cmdline & path source for ":"
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
            {{ name = "path" }},
            {{ name = "cmdline" }}
        )
    })
end

return M
