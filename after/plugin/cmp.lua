-- nvim-cmp
if not Check_loaded_plugin("nvim-cmp") then return end

local cmp = require("cmp")
cmp.setup({
    formatting = {
        -- Suggestions order :h formatting.fields
        fields = { "abbr", "menu", "kind" },
        -- Add suggestion source
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
    -- cmp menu key adjustment
    mapping = {
        ["<C-j>"] = cmp.mapping.confirm({ select = true }),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Up>"] = cmp.mapping.select_prev_item({ select = true }),
        ["<Down>"] = cmp.mapping.select_next_item({ select = true }),
        ["<C-p>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({ select = true })
            else
                cmp.complete()
            end
        end),
        ["<C-n>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({ select = true })
            else
                cmp.complete()
            end
        end),
    },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "path" },
        { name = "luasnip", option = { use_show_condition = false } },
        { name = "nvim_lsp" },
        { name = "cmp_luasnip" },
        { name = "buffer",  keyword_length = 3 },
    },
    -- Add border to popup window
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})
