--- TODO, FIX, etc. comments highlights
return {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope" },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "todo-comments: Next todo comment" },
        { "[t", function() require("todo-comments").jump_prev() end, desc = "todo-comments: Previous todo comment" },
        { "<leader>ft", "<CMD>TodoTelescope<CR>", desc = "todo-comments: Open todo list in telescope" },
        { "<leader>fT", "<CMD>TodoLocList<CR>", desc = "todo-comments: Open todo list in a panel" },
        { "<leader>tl", "<CMD>TodoQuickFix<CR>", desc = "todo-comments: Open quickfix list" },
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
        -- highlight = { exclude = {}, }, -- filetypes to exclude highlighting
    },
}
