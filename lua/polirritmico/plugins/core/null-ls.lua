-- Connects no-LSP tools with the LSP server (black, isort, etc.)

return {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "python" },
    config = function()
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        local null_ls = require("null-ls")
        null_ls.setup({
            debug = false,
            on_attach = function(client, bufnr)
                if vim.bo.filetype == "python" and client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr, async = false })
                        end,
                    })
                end
            end,
            sources = {
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.prettier,
            }
        })
    end,
}
