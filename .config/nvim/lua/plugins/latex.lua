-- Vimtex
--filetype plugin indent on
--syntax enable " on
vim.g.vimtex_view = 0

-- Viewer method:
vim.g.vimtex_view_method = "zathura"

-- Or with a generic interface:
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

-- VimTeX uses latexmk as the default compiler backend.
-- If you want another compiler, the list of supported backends and further
-- explanation is provided in the documentation, see :help vimtex-compiler.
vim.g.vimtex_compiler_method = "latexmk"

-- Quita advertencia
vim.g.vimtex_quickfix_ignore_filters = { 'Underfull', 'Overfull', }

