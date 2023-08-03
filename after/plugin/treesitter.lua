-- Treesitter
if not Check_loaded_plugin("nvim-treesitter") then return end

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash", "html", "make", "python", "regex", "sql", "query",
        "vim", "lua", "vimdoc",
    },
    sync_install = false,
    auto_install = true,
    ignore_install = { "markdown", },
    highlight = {
        enable = true,
        -- Disabled languages. Names of the parsers, not the filetype.
        disable = { "markdown" },
        additional_vim_regex_highlighting = false,
    },
})
