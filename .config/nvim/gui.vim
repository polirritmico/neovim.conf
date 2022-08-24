" *********************************************************
" Colors (Después de pluggins para evitar override)

" Enable vim-monokai-tasty scheme
let g:vim_monokai_tasty_italic = 1      " Allow italics. Set before coloscheme!
colorscheme vim-monokai-tasty

autocmd ColorScheme * hi Normal ctermbg=NONE guibg=NONE
syntax on                  " Coloreo de sintaxis básico
set termguicolors	       " Activa colores
set background=dark        " Dark o light

" Resaltado línea actual:
set cursorline		       
hi Cursorline guibg=NONE

" Deshabilita el highlight en las búsquedas
set nohlsearch

