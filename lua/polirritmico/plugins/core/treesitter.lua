--- Treesitter: Syntactic analysis

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
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
            "bash",
            "c",
            "diff",
            "html",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "luap",
            "make",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "toml",
            "sql",
            "vim",
            "vimdoc",
            "yaml",
        },
    },
    config = function(_, opts)
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
            if added[lang] then
                return false
            end
            added[lang] = true
            return true
        end, opts.ensure_installed)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
