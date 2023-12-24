-- Snippets

return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    opts = {
        enable_autosnippets = false,
        -- Don't jump into snippets that have been left
        history = true,
        delete_check_events = "TextChanged,InsertLeave",
        region_check_events = "CursorMoved",
    },
    -- event = "VeryLazy",
    config = function(_, opts)
        local ls = require("luasnip")
        local types = require("luasnip.util.types")

        -- Add custom snippets
        local custom_snips = vim.fn.stdpath("config") .. "/lua/" .. MyUser .. "/snippets/"
        require("luasnip.loaders.from_lua").load({ paths = custom_snips })

        -- Add virtual marks on inputs
        opts.ext_opts = {
            [types.choiceNode] = {
                active = { virt_text = { { "← Choice", "Conceal" } }, },
                pasive = { virt_text = { { "← Choice", "Comment" } }, },
            },
            [types.insertNode] = {
                active = { virt_text = { { "← Insert", "Conceal" } }, },
                pasive = { virt_text = { { "← Insert", "Comment" } }, },
            },
        }
        ls.setup(opts)
    end,
    keys = function()
        local ls = require("luasnip")
        local ls_mode = {"i", "s"}
        local function expand_or_jump_next() if ls.expand_or_jumpable() then ls.expand_or_jump() end end
        local function jump_next() if ls.jumpable(1) then ls.jump(1) end end
        local function jump_prev() if ls.jumpable(-1) then ls.jump(-1) end end
        local function cycle_next_choice() if ls.choice_active() then return "<Plug>luasnip-next-choice" end end
        local function cycle_prev_choice() if ls.choice_active() then return "<Plug>luasnip-prev-choice" end end

        return {
            { "<c-j>", expand_or_jump_next, mode = ls_mode,
                desc = "LuaSnip: Expand snippet or jump to the next input index.", silent = true },
            { "<c-f>", jump_next, mode = ls_mode,
                desc = "LuaSnip: Jump to the next input index.", silent = true },
            { "<c-k>", jump_prev, mode = ls_mode,
                desc = "LuaSnip: Jump to the previous input index.", silent = true },
            { "<c-l>", cycle_next_choice, mode = ls_mode,
                desc = "LuaSnip: Cycle to the next choice in the snippet.", silent = true, expr = true },
            { "<c-h>", cycle_prev_choice, mode = ls_mode,
                desc = "LuaSnip: Cycle to the previous choice in the snippet.", silent = true, expr = true },
        }
    end,
}
