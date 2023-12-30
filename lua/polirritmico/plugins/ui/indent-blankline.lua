--- Indentation guide lines

return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	opts = {
		exclude = { filetypes = { "dashboard" } },
		indent = {
			char = { "│" },
			smart_indent_cap = false, -- Get indent level by surrounding code
		},
		scope = { enabled = false },
	},
}
