--- Git: Highlight code changes from last commit
local map = require(MyUser .. ".utils").set_keymap

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "+" }, -- │
      change = { text = "│" }, -- │
      delete = { text = "-" }, -- _
      topdelete = { text = "‾" }, -- ‾
      changedelete = { text = "~" }, -- ~
      untracked = { text = "┆" }, -- ┆
    },
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      delay = 500,
      ignore_whitespace = true,
    },
    preview_config = { border = "rounded" },
    show_deleted = false,
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    attach_to_untracked = false,
    on_attach = function(buffer)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desk })
      end
      local function toggle_gitsigns()
        gs.toggle_deleted()
        gs.toggle_current_line_blame()
        gs.toggle_word_diff()
      end

      map("n", "<leader>gt", toggle_gitsigns, "GitSigns: Toggle show deleted lines")
      map("n", "<leader>gn", gs.next_hunk, "GitSigns: Next file change")
      map("n", "<leader>gp", gs.prev_hunk, "GitSigns: Previous file change")
      map("n", "<leader>gsb", gs.stage_buffer, "GitSigns: Stage buffer")
      map(
        { "n", "v" },
        "<leader>gsh",
        ":Gitsigns stage_hunk<CR>",
        "GitSigns: Stage hunk"
      )
      map(
        { "n", "v" },
        "<leader>grh",
        ":Gitsigns reset_hunk<CR>",
        "GitSigns: Reset hunk"
      )
      map("n", "<leader>gu", gs.undo_stage_hunk, "GitSigns: Undo stage hunk")
      map("n", "<leader>grb", gs.reset_buffer, "GitSigns: Reset buffer")
      map("n", "<leader>gP", gs.preview_hunk, "GitSigns: Preview hunk")
      map("n", "<leader>ga", function()
        gs.blame_line({ full = true })
      end, "GitSigns: Blame line")
      map(
        "n",
        "<leader>gc",
        gs.toggle_current_line_blame,
        "GitSigns: Toggle current line blame"
      )
      map("n", "<leader>gd", gs.diffthis, "GitSigns: Diff this")
      map("n", "<leader>gD", function()
        gs.diffthis("~")
      end, "GitSigns: Diff this")
    end,
  },
}
