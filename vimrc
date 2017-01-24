if &compatible
  set nocompatible
endif

call plug#begin('~/.vim/plugged')

" general editing
Plug 'ervandew/supertab' "tab completion
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "fuzzy finder
Plug 'junegunn/fzf.vim' "finder vim bindings
Plug 'nviennot/molokai' "colors
Plug 'tpope/vim-endwise' "end blocks
Plug 'tpope/vim-fugitive'  "git
Plug 'tpope/vim-repeat'  "repeat custom commands
Plug 'tpope/vim-surround'  "repeat custom commands
Plug 'scrooloose/nerdtree' "filesystem explorer
Plug 'Xuyuanp/nerdtree-git-plugin' "git status for NERDTree
Plug 'scrooloose/nerdcommenter' "easy commenting
Plug 'vim-airline/vim-airline' "status bar

" gists
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'

" ruby
Plug 'tpope/vim-rails', { 'for': 'ruby' }

" typescript
Plug 'leafgarland/typescript-vim'

" markdown
Plug 'junegunn/vim-xmark', { 'do': 'make' }

" scss
Plug 'cakebaker/scss-syntax.vim'

call plug#end()

" Display options
colorscheme molokai

filetype plugin indent on
syntax on
set t_Co=256
set number
set nowrap
set lazyredraw
set nocursorline

runtime macros/matchit.vim

set backspace=eol,start,indent  " Allow backspacing over indent, eol, & start
set smarttab                    " Make <tab> and <backspace> smarter
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

au BufRead,BufNewFile *.md setf markdown
au BufRead,BufNewFile *.rake,*.rabl,*.jbuilder setf ruby

set laststatus=2

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Misc
set noswapfile
set nobackup

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch
map <Leader>/ :nohlsearch<cr>

set wildmenu
set wildmode=list:longest,full

" Show me where 80 chars is
set colorcolumn=80
hi ColorColumn ctermbg=235 guibg=#2c2d27

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

"""""""""""""""""""""""""
" Keybindings
"""""""""""""""""""""""""
let mapleader=','
let localmapleader=','

map <Leader>w :set invwrap<cr>
map <Leader>p :set invpaste<cr>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize window splits
nnoremap <Up>    3<C-w>-
nnoremap <Down>  3<C-w>+
nnoremap <Left>  3<C-w><
nnoremap <Right> 3<C-w>>

nnoremap <S-l> gt
nnoremap <S-h> gT

noremap k gk
noremap j gj
nnoremap <leader>pi :source ~/.vimrc<cr>:PlugInstall<cr>

" json
nnoremap <silent> <leader>jj :%!python -m json.tool<cr>

" fzf shortcuts
let g:fzf_history_dir = '~/.local/share/fzf-history'
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <Leader>h :History<cr>
nnoremap <Leader>a :Ag

" open netrw
nnoremap <silent> <Leader>v :Vexplore<cr>
nnoremap <silent> <Leader>s :Sexplore<cr>

" NERDTree
nnoremap <C-g> :NERDTreeToggle<cr>
nnoremap <C-f> :NERDTreeFind<cr>

vnoremap s :!sort<CR>

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
nnoremap <Leader>n :call RenameFile()<cr>

function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

if filereadable(expand("~/.custom.vim"))
  source ~/.custom.vim
endif
