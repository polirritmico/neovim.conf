-- Doge
local plugin_name = "vim-doge"
if not Check_loaded_plugin(plugin_name) then
    return
end

vim.g.doge_doc_standard_python = "google"
vim.g.doge_mapping = "<Leader>dd"

