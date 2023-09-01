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
})

-- Mappings
Keymap({"n", "v"}, "<leader>ft", ":TodoTelescope<CR>", "todo-comments: Open todo list in telescope")
Keymap({"n", "v"}, "<leader>fT", ":TodoLocList<CR>", "todo-comments: Open todo list in a panel")
Keymap({"n", "v"}, "<leader>tl", ":TodoQuickFix<CR>", "todo-comments: Open quickfix list")
