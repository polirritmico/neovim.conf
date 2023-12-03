-- Treesitter
if not Check_loaded_plugin("nvim-treesitter") then return end

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash", "html", "make", "markdown", "markdown_inline", "python",
        "regex", "sql", "query", "vim", "lua", "vimdoc",
    },
    sync_install = true,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

if Check_loaded_plugin("nvim-treesitter-context") then
    require("treesitter-context").setup({
        min_window_height = 10, -- in lines
    })
end
