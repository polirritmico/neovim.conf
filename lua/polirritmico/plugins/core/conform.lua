-- Formatter
return {
    "stevearc/conform.nvim",
    enabled = false,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {{
        "<F3>",
        function() require("conform").format({ async = false, lsp_fallback = true }) end,
        mode = "",
        desc = "Conform: Format buffer",
    }},
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
        formatters = {
            shfmt = { prepend_args = { "-i", "2" } },
            -- stylua = { indent_type = "Spaces" },
        },
    },
    init = function()
        vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
    end,
}
