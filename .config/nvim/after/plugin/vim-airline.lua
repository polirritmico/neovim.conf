-- Vim-airline (status bar)
if type(packer_plugins) ~= "table" or packer_plugins["vim-airline"] == nil then
	return
end

vim.cmd([[
let g:airline_theme='monokai_tasty'
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 79,
    \ 'x': 60,
    \ 'y': 88,
    \ 'z': 45,
    \ 'warning': 80,
    \ 'error': 80,
\ }]])

--
-- +---------------------------------------------------------------+
-- |~                                                              |
-- |~                                                              |
-- |~                 VIM - Vi IMproved                            |
-- |~                                                              |
-- |~                   version 8.0                                |
-- |~                by Bram Moolenaar et al.                      |
-- |~       Vim is open source and freely distributable            |
-- |~                                                              |
-- |~       type :h :q<Enter>          to exit                     |
-- |~       type :help<Enter> or <F1>  for on-line help            |
-- |~       type :help version8<Enter> for version info            |
-- |~                                                              |
-- |~                                                              |
-- +---------------------------------------------------------------+
-- | A | B |                   C                X | Y | Z |  [...] |
-- +---------------------------------------------------------------+

