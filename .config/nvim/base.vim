" ******************************************************
" Editor
"set title		           " Filename en ventana. Da problemas en tiling wm
set number relativenumber  " Muestra números de línea relativos
set wrap linebreak		   " Divide líneas largas
set colorcolumn=80	       " Límite de columna
set noerrorbells           " Deshabilita anuncios de errores
set hidden                 " Cambiar buffer sin grabar
set mouse=a		           " Agrega soporte para el ratón

set timeout                " Tiempo de espera para las combinaciones de teclas
set timeoutlen=2000        " 1000 ms por defecto

" Indentación
set tabstop=4
set shiftwidth=0
set softtabstop=4
set shiftround		       " aproxima la indentación en multiplos de shiftwidth
set expandtab		       " Reemplaza tab por espacios
set smartindent            " Intentará indentar

" Backups
set noundofile             " Al cerrar sin guardar da error al volver a abrir
set nobackup               " Lo mismo

" Búsquedas
set incsearch              " Mientras busca muestra resultados 

" Idioma
"set spelllang=en	       " Diccionarios
"set helplang=en           " ayuda en inglés
language en_US.utf8

" Autocompletion
"set complete+=kspell
"set completeopt=menuone,longest
"set shortmess+=c

" Plegado de código
set foldmethod=indent      " Opciones: indent, syntax
set foldnestmax=2          " ?
set nofoldenable           " Evita plegado al abrir archivo
" Desplegado al abrir
"au BufRead * normal zR

"set foldlevel=1
"set foldclose=all

" Buscar en subdirectorios con tab completion
set path+=**

" *********************************************************
" División de pantalla
" Ayuda a la izquierda o arriba si la pantalla ya está dividida
"augroup my_filetype_settings:
"autocmd!
"autocmd FileType help if winnr('$') > 2 | wincmd K | else | wincmd L | endif
"augroup END

" *********************************************************
" Guardar sesiones
set wildmenu
set wildmode=full
let g:sessions_dir = '~/.local/share/nvim/sessions'

" *********************************************************
" Crea 'tags' del archivo (requiere ctags instalado en el sistema)
" para poder ir rápidamente a definiciones incluso en archivos
" diferentes al actual.
command! MakeTags !ctags -R .

