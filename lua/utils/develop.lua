local M = {}

function M.require_ts() end

function M.jump_to_next_node(node_type)
  P("Run:")
  local ts = require("nvim-treesitter")
  local parsers = require("nvim-treesitter.parsers")

  local bufnr = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_win_get_cursor(0)
  local node = "atx_heading"
  local out = ts.get_node_text(node, 0)
end

function M.node(node)
  -- test
end

return M
