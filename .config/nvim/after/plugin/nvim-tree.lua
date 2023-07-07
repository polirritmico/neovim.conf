-- Nvim Tree
local plugin_name = "nvim-tree.lua"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Deshabilitar netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true


-- Configurar atajos de NvimTree:
local function my_on_attach(bufnr)
    local tree_api = require("nvim-tree.api")
    local function opts(desc)
        return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
        }
    end
    -- Atajos por defecto
    tree_api.config.mappings.default_on_attach(bufnr)

    -- Atajos personalizados
    -- vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
    -- vim.keymap.set("n", "?", api.tree.toogle_help, opts("Help"))
end

-- Atajo para abrir/cerrar
vim.keymap.set("n", "<leader>fe", ":NvimTreeToggle<CR>", {silent=true})
vim.keymap.set("n", "<leader>fE", ":lua require('nvim-tree').tree.toggle({path=vim.api.nvim_buf_get_name(0)})<CR>", {silent=true})

require("nvim-tree").setup({
    on_attach = my_on_attach,
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})


