-- todo-comments
local plugin_name = "todo-comments.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Style test:
-- TODO: Some text
-- NOTE: Some text
-- WARNING: Some text
-- HACK: Some text
-- PERF: Some text
-- FIX: Some text
-- TEST: Some text

require("todo-comments").setup({
    signs = true,      -- show icons in the signs column
    sign_priority = 8, -- sign priority
    keywords = {
        --     ﰹ ﯽ 﫚齃理獵龍裂凜                 ﭔ
        FIX = { icon = " ", color = "magenta", alt = { "FIXME", "BUG", "ISSUE" } },
        TODO = { icon = "凜", color = "purple" },
        HACK = { icon = " ", color = "yellow" },
        WARN = { icon = " ", color = "orange", alt = { "WARNING" } },
        PERF = { icon = " ", color = "white", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "green", alt = { "INFO" } },
        TEST = { icon = "", color = "blue", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    colors = {
        blue    = { "#62D8F1" },
        green   = { "#A4E400" },
        magenta = { "#FC1A70" },
        orange  = { "#FF9700" },
        purple  = { "#AF87FF" },
        yellow  = { "#F6F557" },
        white   = { "#FFFFFF" },
    },
    merge_keywords = true,
    highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",                     -- "fg" or "bg" or empty
        keyword = "wide",                -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty.
        after = "fg",                    -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true,            -- uses treesitter to match keywords in comments only
        max_line_len = 400,              -- ignore lines longer than this
        exclude = {},                    -- list of file types to exclude highlighting
    },
    search = {
        command = "rg",
        args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    },
})
