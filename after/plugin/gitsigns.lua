if not Check_loaded_plugin("gitsigns.nvim") then return end

require("gitsigns").setup({
    show_deleted = true,
    -- current_line_blame = true,
    -- current_line_blame_opts = {
    --     virt_text = true,
    -- },

    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    -- numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    -- linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    -- word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
    -- linehl     = true, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = true, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        follow_files = true
    },
    attach_to_untracked = true,
    -- current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1
    },
    yadm = {
        enable = false
    },
})

local gitsigns = require("gitsigns")
Keymap({"n", "v"}, "<leader>gsb", gitsigns.stage_buffer) -- git stage buffer
Keymap({"n", "v"}, "<leader>gsh", gitsigns.stage_hunk) -- git stage hunk
Keymap({"n", "v"}, "<leader>gu", gitsigns.undo_stage_hunk) -- git undo
Keymap({"n", "v"}, "<leader>grb", gitsigns.reset_buffer) -- git Reset buffer
Keymap({"n", "v"}, "<leader>grh", gitsigns.reset_hunk) -- git Reset buffer
Keymap({"n", "v"}, "<leader>gp", gitsigns.preview_hunk) -- git preview
Keymap({"n", "v"}, "<leader>ga", function() gitsigns.blame_line({full=true}) end) -- git author?
Keymap({"n", "v"}, "<leader>gc", gitsigns.toggle_current_line_blame) -- git creator
Keymap({"n", "v"}, "<leader>gd", gitsigns.diffthis) -- git diff
Keymap({"n", "v"}, "<leader>gD", function() gitsigns.diffthis("~") end) -- git Diff
Keymap({"n", "v"}, "<leader>gt", gitsigns.toggle_deleted) -- git toggle
