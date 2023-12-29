--- Auto completion (full config in ../setups/cmp.lua)
return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
        -- dunder/private "_" methods to the btm

        local cmp = require("cmp")
        local defaults = require("cmp.config.default")()
        local luasnip = require("luasnip")

        return {
            completion = { completeopt = "menu,menuone,noinsert" },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
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
            sources = cmp.config.sources({
                -- Order of cmp menu entries
                { name = "luasnip", option = { use_show_condition = false } },
                { name = "path" },
                { name = "nvim_lsp" },
                { name = "cmp_luasnip" }
            }, {
                { name = "buffer", keyword_lentgth = 3 },
            }),
            formatting = {
                expandable_indicator = true, -- shows the ~ symbol when expandable
                fields = { "abbr", "menu", "kind" }, -- suggestions order :h formatting.fields
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
            experimental = {
                ghost_text = { hl_group = "CmpGhostText" },
            },
            sorting = vim.tbl_extend("force", defaults.sorting, {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    -- Dunder and Private methods
                    function(entry1, entry2)
                        local _, entry1_under = entry1.completion_item.label:find("^_+")
                        local _, entry2_under = entry2.completion_item.label:find("^_+")
                        entry1_under = entry1_under or 0
                        entry2_under = entry2_under or 0
                        if entry1_under > entry2_under then
                            return false
                        elseif entry1_under < entry2_under then
                            return true
                        end
                    end,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                }
            }),
            -- Add border to popup window
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered()
            },
        }
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        cmp.setup(opts)

        -- Use cmdline & path source for ":"
        cmp.setup.cmdline(":", {
            -- mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources(
                {{ name = "path" }}, {{ name = "cmdline" }}
            )
        })
    end,
}
