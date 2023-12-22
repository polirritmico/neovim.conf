--- TODO, FIX, etc. comments highlights

-- local map = require(MyUser .. ".utils").set_keymap

return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    keys = {
        {"<leader>ft", ":TodoTelescope<CR>", {"n", "v"},
            desc = "todo-comments: Open todo list in telescope", silent = true},
        {"<leader>fT", ":TodoLocList<CR>", {"n", "v"},
            desc = "todo-comments: Open todo list in a panel", silent = true},
        {"<leader>tl", ":TodoQuickFix<CR>", {"n", "v"},
            desc = "todo-comments: Open quickfix list", silent = true},
    },
    opts = {
        -- Style test:
        -- FIX: Some text
        -- HACK: Some text
        -- NOTE: Some text
        -- PERF: Some text
        -- TEST: Some text
        -- TODO: Some text
        -- WARNING: Some text
        keywords = {
            -- Alternative icons:       󰈸  󱗗 
            FIX  = { icon = "", alt = { "FIXME", "BUG", "ISSUE", "ERROR" } },
            HACK = { icon = "" },
            NOTE = { icon = "󰍨", alt = { "INFO", "NOTA" } },
            PERF = { icon = "󰅒", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            TEST = { icon = "", alt = { "TESTING" } },
            TODO = { icon = "󰑕" },
            WARN = { icon = "", alt = { "WARNING" } },
        },
        highlight = {
            pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns
            exclude = {}, -- filetypes to exclude highlighting
        },
        search = {
            pattern = [[\b(KEYWORDS):]], -- Don't change "KEYWORDS" in the regex
        },
    },
}
