--- Treesitter: Syntactic analysis

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = {
            "bash", "html", "make", "markdown", "markdown_inline", "python",
            "regex", "sql", "query", "vim", "lua", "vimdoc",
        },
        sync_install = true,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        }
    },
}
