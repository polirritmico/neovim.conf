-- Treesitter: Parse program langs for highlights, indent, conceals, etc.
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
  init = function(plugin)
    -- PERF: (From LazyVim): Add TS queries to the rtp early for plugins
    -- which don't trigger **nvim-treesitter** module to be loaded in time.
    -- This make available the custom queries needed by those plugins.
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,
  opts = {
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "comment",
      "gitcommit",
      "lua",
      "markdown",
      "python",
      "regex",
      "vim",
      "vimdoc",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
