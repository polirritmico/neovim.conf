-- todo-comments
if not Check_loaded_plugin("todo-comments.nvim") then return end

-- Style test:
-- FIX: Some text
-- HACK: Some text
-- NOTE: Some text
-- PERF: Some text
-- TEST: Some text
-- TODO: Some text
-- WARNING: Some text

require("todo-comments").setup({
    colors = {
        blue    = { "#62D8F1" },
        green   = { "#A4E400" },
        magenta = { "#FC1A70" },
        orange  = { "#FF9700" },
        purple  = { "#AF87FF" },
        yellow  = { "#F6F557" },
        white   = { "#FFFFFF" },
        grey    = { "#BCBCBC" },
    },
    keywords = {
        -- Alternative icons:       󰈸  󱗗 
        FIX  = { icon = "", color = "magenta", alt = { "FIXME", "BUG", "ISSUE" } },
        HACK = { icon = "", color = "orange" },
        NOTE = { icon = "󰍨", color = "yellow", alt = { "INFO" } },
        PERF = { icon = "󰅒", color = "blue", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        TEST = { icon = "", color = "green", alt = { "TESTING", "PASSED", "FAILED" } },
        TODO = { icon = "󰑕", color = "purple" },
        WARN = { icon = "", color = "orange", alt = { "WARNING" } },
    },
    merge_keywords = true,
    highlight = {
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        exclude = {}, -- list of file types to exclude highlighting
    },
    search = {
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    },
})

-- Mappings
Keymap({"n", "v"}, "<leader>ft", ":TodoTelescope<CR>", "todo-comments: Open todo list in telescope")
Keymap({"n", "v"}, "<leader>fT", ":TodoLocList<CR>", "todo-comments: Open todo list in a panel")
