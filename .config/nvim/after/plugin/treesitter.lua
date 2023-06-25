-- Treesitter
local plugin_name = "nvim-treesitter"
if not Check_loaded_plugin(plugin_name) then
    return
end

require("nvim-treesitter.configs").setup({
    -- A list of parser names. Or "all".
    ensure_installed = {
        "bash", "c", "c_sharp", "cpp", "css", "gdscript", "html", "javascript",
        "make", "python", "regex", "sql", "vim", "lua", "vimdoc", "query",
        "rust", "typescript", "cpp"
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    auto_install = true,
    -- List of parsers to ignore installing (for "all")
    -- Latex: Handled by VimTeX
    ignore_install = { "latex", "markdown" },
    highlight = {
        enable = true,
        -- Disabled languages. Names of the parsers, not the filetype.
        disable = { "latex", "markdown" },
        additional_vim_regex_highlighting = false,
    },
})
