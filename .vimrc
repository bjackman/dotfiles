version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
let &cpo=s:cpo_save
unlet s:cpo_save

set textwidth=80
set number
set autoindent
set backspace=indent,eol,start
set cscopeprg=/usr/bin/cscope
set cscopetag
set cscopeverbose
set expandtab
set guicursor=n-v-c:block,o:hor50,i-ci:hor15,r-cr:hor30,sm:block,a:blinkon0
set helplang=en
set history=50
set hlsearch
set ruler
set smartindent
set wildmenu
"set viminfo='20,\"50
set viminfo='100,f1
"creates a 3 line gap (scroll offset) between the cursor and the edge of the buffer
set scrolloff=3
set ttyfast
"an experiment - perhaps useful for stuff like d13j where you guess?!
set relativenumber

function! TabPolicy(num_spaces)
  set expandtab
  set smarttab
  let &tabstop=a:num_spaces
  let &softtabstop=a:num_spaces
  let &shiftwidth=a:num_spaces
endfunction
call TabPolicy(2)

" vim: set ft=vim :
"from vim wim.wikia: to make ctrl and alt j/k insert/delete blank lines
nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

colorscheme desert
:au FocusLost * silent! wa

function! Edk2()
  call TabPolicy(2)
  set ff=dos
endfunction

"CAPSLOCK
"http://vim.wikia.com/wiki/Insert-mode_only_Caps_Lock
" Execute 'lnoremap x X' and 'lnoremap X x' for each letter a-z.
for c in range(char2nr('A'), char2nr('Z'))
  execute 'lnoremap ' . nr2char(c+32) . ' ' . nr2char(c)
  execute 'lnoremap ' . nr2char(c) . ' ' . nr2char(c+32)
endfor
" Kill the capslock when leaving insert mode.
autocmd InsertLeave * set iminsert=0
