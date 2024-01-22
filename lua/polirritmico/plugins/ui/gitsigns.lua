--- Git: Highlight code changes from last commit
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
    -- stylua: ignore
    on_attach = function(buffer)
      local gs = require("gitsigns")
      local function cmap(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
      end

      local function toggle_gitsigns()
        gs.toggle_deleted()
        gs.toggle_current_line_blame()
        gs.toggle_word_diff()
      end
      cmap("n", "<leader>gt", toggle_gitsigns, "GitSigns: Toggle show deleted lines")
      cmap("n", "<leader>gn", gs.next_hunk, "GitSigns: Next file change")
      cmap("n", "<leader>gp", gs.prev_hunk, "GitSigns: Previous file change")
      cmap("n", "<leader>gsb", gs.stage_buffer, "GitSigns: Stage buffer")
      cmap({ "n", "v" }, "<leader>gsh", ":Gitsigns stage_hunk<CR>", "GitSigns: Stage hunk")
      cmap({ "n", "v" }, "<leader>grh", ":Gitsigns reset_hunk<CR>", "GitSigns: Reset hunk")
      cmap("n", "<leader>gu", gs.undo_stage_hunk, "GitSigns: Undo stage hunk")
      cmap("n", "<leader>grb", gs.reset_buffer, "GitSigns: Reset buffer")
      cmap("n", "<leader>gP", gs.preview_hunk, "GitSigns: Preview hunk")
      cmap("n", "<leader>ga", function() gs.blame_line({ full = true }) end, "GitSigns: Blame line")
      cmap("n", "<leader>gc", gs.toggle_current_line_blame, "GitSigns: Toggle current line blame")
      cmap("n", "<leader>gd", gs.diffthis, "GitSigns: Diff this")
      cmap("n", "<leader>gD", function() gs.diffthis("~") end, "GitSigns: Diff this")
    end,
  },
}
