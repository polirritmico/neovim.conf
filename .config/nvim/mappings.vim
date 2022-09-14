" *********************************************************
" *                       MAPPINGS                        *
" *********************************************************

" *********************************************************
" Remappings

" Cambiar tecla líder a espacio
let g:mapleader = ' '

" Líder local que cambia la función dependiendo el tipo de archivo abierto 
let maplocalleader = ","

" Cambiar la tecla de comandos a la ñ, misma posición de ANSI
map ñ :
map Ñ ;

" Cambiar goto mark. No reconoce `
nmap <bar> `

" Cambiar dirección de las flechas al explorar archivos con :e
set wildcharm=<C-Z>
cnoremap <expr> <up> getcmdline()[:1] is 'e ' && wildmenumode() ?
            \ "\<left>" : "\<up>"
cnoremap <expr> <down> getcmdline()[:1] is 'e ' && wildmenumode() ?
            \ "\<right>" : "\<down>"
cnoremap <expr> <left> getcmdline()[:1] is 'e ' && wildmenumode() ?
            \ "\<up>" : "\<left>"
cnoremap <expr> <right> getcmdline()[:1] is 'e ' && wildmenumode() ?
            \ " \<bs>\<C-Z>" : "\<right>"

" *********************************************************
" Helpers

" Moverse entre buffers
nnoremap <leader>l  :bnext<CR>
nnoremap <leader>h  :bprevious<CR>
" Cerrar buffer sin cerrar ventana
nnoremap <leader>db  :bp<bar>sp<bar>bn<bar>bd<CR>

" Regresar al archivo anterior
nnoremap <leader>gb  <C-^>

" Clipboard. * para selección y + para el clipboard
nnoremap <leader>y  "+y
nnoremap <leader>Y  "*Y
vnoremap <leader>y  "+y
vnoremap <leader>Y  "*Y
nnoremap <leader>p  "+p
nnoremap <leader>P  "*P
vnoremap <leader>p  "+p
vnoremap <leader>P  "*P

" Plegado de código (foldmethod=indent en base.vim)
nnoremap <leader><space> za
vnoremap <leader><space> zf

" Para moverse en modo visual más rápido (en lugar de gj, gk, etc.)
" A = tecla alt
"vmap <A-j> gj
"vmap <A-k> gk
"nmap <A-j> gj
"nmap <A-k> gk

" Recargar comfiguración sin reinciar
nmap <leader>CR :source $MYVIMRC<CR>

nmap <leader>CC :e $XDG_CONFIG_HOME/nvim/init.vim<CR>
nmap <leader>CM :e $XDG_CONFIG_HOME/nvim/mappings.vim<CR>
nmap <leader>CP :e $XDG_CONFIG_HOME/nvim/plugins.vim<CR>
nmap <leader>CB :e $XDG_CONFIG_HOME/nvim/base.vim<CR>
nmap <leader>CG :e $XDG_CONFIG_HOME/nvim/gui.vim<CR>
nmap <leader>CA :e $XDG_CONFIG_HOME/nvim/aliases.vim<CR>



" *********************************************************
" Functions

" Custom functions in ~/.config/nvim/functions/
" Bind the BufSel() function to a user-command
"command! -nargs=1 Bs :call BufSel("<args>")

" Guardar y cargar sesión
exec 'nnoremap <Leader>ss :mks! ' .
            \ g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
exec 'nnoremap <Leader>sr :so ' .
            \ g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'

" Quitar espacios con F5
"nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>



" *********************************************************
" Runners
autocmd FileType python noremap <leader>rr :! python __main__.py<CR>
autocmd FileType python noremap <leader>rd :! python -m pdb __main__.py<CR>

" *********************************************************
" Unittest Python
autocmd FileType python
            \ nnoremap <leader>rt :! python -m unittest discover . -b<CR>
autocmd FileType python
            \ nnoremap <leader>rT :! python -m unittest discover .<CR>

autocmd FileType python
            \ nnoremap <leader>ts :%s/ #@unittest.skip/ @unittest.skip/<CR>
autocmd FileType python
            \ nnoremap <leader>tS :%s/ @unittest.skip/ #@unittest.skip/<CR>


" *********************************************************
" Plugins

" Debugger
nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <F3> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F2> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <Leader>do <Cmd>lua require'dap'.repl.open()<CR>
nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.run_last()<CR>
nnoremap <silent> <Leader>dg <Cmd>lua require'dapui'.toggle()<CR>


" UltiSnips
" Trigger
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"


