--- Git: Highlight code changes from last commit

return {
    "lewis6991/gitsigns.nvim",
    keys = function()
        local gitsigns = require("gitsigns")
        local function toggle_gitsigns()
            gitsigns.toggle_deleted()
            gitsigns.toggle_current_line_blame()
            gitsigns.toggle_word_diff()
        end
        return{
            { "<leader>gt", toggle_gitsigns, mode = {"n", "v"},
                desc = "GitSigns: Toggle show deleted lines", silent = true },
            { "<leader>gn", gitsigns.next_hunk, mode = {"n", "v"},
                desc = "GitSigns: Next file change", silent = true },
            { "<leader>gp", gitsigns.prev_hunk, mode = {"n", "v"},
                desc = "GitSigns: Previous file change", silent = true },
            { "<leader>gsb", gitsigns.stage_buffer, mode = {"n", "v"},
                desc = "GitSigns: Stage buffer", silent = true },
            { "<leader>gsh", gitsigns.stage_hunk, mode = {"n", "v"},
                desc = "GitSigns: Stage hunk", silent = true },
            { "<leader>gu", gitsigns.undo_stage_hunk, mode = {"n", "v"},
                desc = "GitSigns: Undo stage hunk", silent = true },
            { "<leader>grb", gitsigns.reset_buffer, mode = {"n", "v"},
                desc = "GitSigns: Reset buffer", silent = true },
            { "<leader>grh", gitsigns.reset_hunk, mode = {"n", "v"},
                desc = "GitSigns: Reset hunk", silent = true },
            { "<leader>gP", gitsigns.preview_hunk, mode = {"n", "v"},
                desc = "GitSigns: Preview hunk", silent = true },
            { "<leader>ga", function() gitsigns.blame_line({full=true}) end, mode = {"n", "v"},
                desc = "GitSigns: Show hunk full info of the line", silent = true },
            { "<leader>gc", gitsigns.toggle_current_line_blame, mode = {"n", "v"},
                desc = "GitSigns: Toggle show line author change", silent = true },
            { "<leader>gd", gitsigns.diffthis, mode = {"n", "v"},
                desc = "GitSigns: Diff this", silent = true },
            { "<leader>gD", function() gitsigns.diffthis("~") end, mode = {"n", "v"},
                desc = "GitSigns: Diff this", silent = true },
        }
    end,
    opts = {
        signs = {
            add          = { text = '+' }, -- │
            change       = { text = '│' }, -- │
            delete       = { text = '-' }, -- _
            topdelete    = { text = '‾' }, -- ‾
            changedelete = { text = '~' }, -- ~
            untracked    = { text = '┆' }, -- ┆
        },
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        attach_to_untracked = false,
        show_deleted = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            delay = 500,
            ignore_whitespace = true,
        },
        preview_config = {
            -- Options passed to nvim_open_win
            border = "rounded",
        },
    }
}
