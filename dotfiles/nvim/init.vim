set tabstop=2
set expandtab

set incsearch
set inccommand=nosplit
set hlsearch

set relativenumber
set number
set numberwidth=4

set smartcase
set ignorecase

set list
set splitright
set undofile
set ruler
set termguicolors
set smartindent
set cursorline
set hidden
set splitbelow
set nospell
set noswapfile
set nowritebackup
set nobackup
set nowrap
set cmdheight=2
set scrolloff=10
set sidescrolloff=10
set conceallevel=0
set updatetime=100
set history=1000
set laststatus=3
set shiftwidth=8
set timeoutlen=300
set signcolumn=yes
set showtabline=0
set shell=/bin/bash
set mouse+=a
set syntax=enable
set clipboard+=unnamedplus

set fileencoding=utf-8
set encoding=utf-8
filetype plugin on


colorscheme torte
set background=dark
hi Comment guifg=#ff5e7e

set undodir=~/.config/nvim/undodir

set path+=**
set formatoptions-=cro
set iskeyword+=-



let mapleader = " "

nmap , @@
nmap <silent> <C-k> :resize +2<CR>
nmap <silent> <C-j> :resize -2<CR>
nmap <silent> <C-l> :vertical resize -2<CR>
nmap <silent> <C-h> :vertical resize +2<CR>
nmap <C-=> <C-w>=
cmap <C-j> <C-n>
cmap <C-k> <C-p>
cmap <C-h> <Left>
cmap <C-l> <Right>
nmap <leader>w :w<cr>
nmap <leader>q :conf q<cr>
vmap < <gv
vmap > >gv

imap kj <C-c>
vmap kj <C-c>
xmap kj <C-c>
cmap kj <C-c>

nmap <silent> <M-k> :wincmd k<cr>
nmap <silent> <M-j> :wincmd j<cr>
nmap <silent> <M-l> :wincmd l<cr>
nmap <silent> <M-h> :wincmd h<cr>

nmap <silent> <M-K> :wincmd K<cr>
nmap <silent> <M-J> :wincmd J<cr>
nmap <silent> <M-L> :wincmd L<cr>
nmap <silent> <M-H> :wincmd H<cr>

imap [ [<c-g>u
imap ] ]<c-g>u
imap ( (<c-g>u
imap , ,<c-g>u
imap . .<c-g>u
imap ! !<c-g>u
imap ? ?<c-g>u
imap < <<c-g>u
imap > ><c-g>u
imap = =<c-g>u
