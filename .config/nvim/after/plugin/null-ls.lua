-- null-ls
local plugin_name = "null-ls.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

local null_ls = require("null-ls")
null_ls.setup({
    debug = false,
    on_attach = function(client, bufnr)
        if vim.bo.filetype == "python" then
            require("lsp-zero").async_autoformat(client, bufnr)
        end
    end,
    sources = {
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black, -- .with({extra_args = {"--fast"}})
    }
})
