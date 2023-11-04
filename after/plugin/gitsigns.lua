-- GitSigns
if not Check_loaded_plugin("gitsigns.nvim") then return end

require("gitsigns").setup({
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
})

local gitsigns = require("gitsigns")
local toggle_gitsigns = function()
    gitsigns.toggle_deleted()
    gitsigns.toggle_current_line_blame()
    gitsigns.toggle_word_diff()
end
Keymap({"n", "v"}, "<leader>gn", gitsigns.next_hunk, "GitSigns: Next file change")
Keymap({"n", "v"}, "<leader>gp", gitsigns.prev_hunk, "GitSigns: Previous file change")
Keymap({"n", "v"}, "<leader>gsb", gitsigns.stage_buffer, "GitSigns: Stage buffer")
Keymap({"n", "v"}, "<leader>gsh", gitsigns.stage_hunk, "GitSigns: Stage hunk")
Keymap({"n", "v"}, "<leader>gu", gitsigns.undo_stage_hunk, "GitSigns: Undo stage hunk")
Keymap({"n", "v"}, "<leader>grb", gitsigns.reset_buffer, "GitSigns: Reset buffer")
Keymap({"n", "v"}, "<leader>grh", gitsigns.reset_hunk, "GitSigns: Reset hunk")
Keymap({"n", "v"}, "<leader>gP", gitsigns.preview_hunk, "GitSigns: Preview hunk")
Keymap({"n", "v"}, "<leader>ga", function() gitsigns.blame_line({full=true}) end, "GitSigns: Show hunk full info of the line")
Keymap({"n", "v"}, "<leader>gc", gitsigns.toggle_current_line_blame, "GitSigns: Toggle show line author change")
Keymap({"n", "v"}, "<leader>gd", gitsigns.diffthis, "GitSigns: Diff this")
Keymap({"n", "v"}, "<leader>gD", function() gitsigns.diffthis("~") end, "GitSigns: Diff this")
Keymap({"n", "v"}, "<leader>gt", toggle_gitsigns, "GitSigns: Toggle show deleted lines")
