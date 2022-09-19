local function map(m, k, v)
	vim.keymap.set(m, k, v, { silent = true })
end

require("telescope").setup({
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true
        }
    },

    map("n", "<leader>ff", "<CMD>Telescope find_files<CR>"),
    map("n", "<leader>fg", "<CMD>Telescope live_grep<CR>"),
    map("n", "<leader>fb", "<CMD>Telescope buffers<CR>"),
    map("n", "<leader>fr", "<CMD>Telescope oldfiles<CR>"),
    map("n", "<leader>fh", "<CMD>Telescope help_tags<CR>")
})

-- Extensiones:
require("telescope").load_extension("fzf")
