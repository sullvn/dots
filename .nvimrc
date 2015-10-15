call plug#begin('~/.nvim/plugins')

" Plugins "
Plug 'Lokaltog/vim-easymotion'

Plug 'scrooloose/syntastic'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --gocode-completer' }
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_confirm_extra_conf = 0

Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'chriskempson/base16-vim'
Plug 'bling/vim-airline'
set laststatus=2
set encoding=utf-8
let g:airline_powerline_fonts = 1

Plug 'raichoo/purescript-vim'

call plug#end()

filetype plugin indent on

" General Settings "
syntax on
set nu

set mouse=a

set incsearch
set hlsearch

set tabstop=4
set smarttab
set shiftwidth=4
set shiftround
set autoindent
set smartindent

set linebreak

set formatoptions-=o
set backupdir=~/.nvim/backup
set directory=~/.nvim/swap

set background=dark
colorscheme base16-eighties
highlight clear SignColumn

set cursorline
set wildmenu
set lazyredraw

set autochdir
