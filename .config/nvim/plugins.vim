" *********************************************************
" Plugins
" *********************************************************
call plug#begin('~/.local/share/nvim/plugged')

" Tema y colores
Plug 'patstockwell/vim-monokai-tasty'

" Barra de estado ajustada
Plug 'vim-airline/vim-airline'

" Para insertar pares de paréntesis, comillas, etc.
Plug 'jiangmiao/auto-pairs'

" Comentarios
Plug 'tpope/vim-commentary'

" Autocomplete (Instrucciones para instalar abajo en la sección)
Plug 'ycm-core/YouCompleteMe'

" Snippets engine
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Syntax highlight
Plug 'vim-python/python-syntax'
Plug 'habamax/vim-godot'

" LaTeX
Plug 'lervag/vimtex'

" Markdown
Plug 'preservim/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }


call plug#end()


" *********************************************************
" Plugins config
" *********************************************************

" *********************************************************
" Varios

" Sintaxis
let g:python_highlight_func_calls = 1
let g:python_highlight_all = 1

" vim-markdown
set conceallevel=2
"let g:vim_markdown_conceal = 2


" *********************************************************
" Auto-pairs
let g:AutoPairsFlyMode = 1


" *********************************************************
" Markdown previewer
"let g:mkdp_browser = 'firefox-bin'


" *********************************************************
" YouCompleteMe
" Info de instalación en: https://github.com/ycm-core/YouCompleteMe#installation
" 1. PlugInstall y cancelar con ctrl+C
" 2. Salir de neovim e ir a ~/.local/share/nvim/plugged/YouCompleteMe
" 3. Volver a descargar el repo: git submodule update --init --recursive
" 4. Compilar e instalar: python3 install.py --clang-completer --ts-completer --cs-completer
" 4. Alt:                 python3 install.py --all
" 5. PlugInstall
" Set to 1 YCM will autoclose the preview window
let g:ycm_autoclose_preview_window_after_insertion = 1

"let g:ycm_complete_in_comments = 1 
"let g:ycm_seed_identifiers_with_syntax = 1 
"let g:ycm_collect_identifiers_from_comments_and_strings = 1 


" *********************************************************
" UltiSnips
" For shortuts go to ~/.config/nvim/mappings.vim
" To split the window
"let g:UltiSnipsEditSplit="vertical"

" UltiSnips stuff 
"let g:UltiSnipsSnippetDirectories = ['/$HOME/.config/nvim/UltiSnips', 'UltiSnips']
"let g:UltiSnipsExpandTrigger = "<nop>"
"inoremap <expr> <CR> pumvisible() ? \
"<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>" : "\<CR>"

" YCM compatibilidad con UltiSnips
"let g:ycm_use_ultisnips_completer = 1
"let g:ycm_key_list_stop_completion = ['<C-y>']


" *********************************************************
" Vimtex
filetype plugin indent on
syntax enable " on
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_compiler_method = 'latexmk'

" viewer method:
let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend.
" If you want another compiler, the list of supported backends and further
" explanation is provided in the documentation, see :help vimtex-compiler.
let g:vimtex_compiler_method = 'latexmk'

" Quita advertencia
let g:vimtex_quickfix_ignore_filters = [
      \ 'Underfull',
      \ 'Overfull',
      \ ]


" *********************************************************
" Vim-airline (status bar)
let g:airline_theme='monokai_tasty'
let g:airline#extensions#default#section_truncate_width = {
  \ 'b': 79,
  \ 'x': 60,
  \ 'y': 88,
  \ 'z': 45,
  \ 'warning': 80,
  \ 'error': 80,
  \ }

"
" +---------------------------------------------------------------+
" |~                                                              |
" |~                                                              |
" |~                 VIM - Vi IMproved                            |
" |~                                                              |
" |~                   version 8.0                                |
" |~                by Bram Moolenaar et al.                      |
" |~       Vim is open source and freely distributable            |
" |~                                                              |
" |~       type :h :q<Enter>          to exit                     |
" |~       type :help<Enter> or <F1>  for on-line help            |
" |~       type :help version8<Enter> for version info            |
" |~                                                              |
" |~                                                              |
" +---------------------------------------------------------------+
" | A | B |                   C                X | Y | Z |  [...] |
" +---------------------------------------------------------------+
"

