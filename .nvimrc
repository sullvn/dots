call plug#begin('~/.nvim/plugins')

" Plugins - Files
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

Plug 'rking/ag.vim'
let g:ag_working_path_mode='r' " use project root instead of cwd

" Plugins - UI
Plug 'bling/vim-airline'
set laststatus=2
let g:airline_powerline_fonts=1

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Plugins - Movement
Plug 'easymotion/vim-easymotion'

" Plugins - Actions
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'

" Plugins - Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Plugins - Theme
Plug 'chriskempson/base16-vim'

" Plugins - Syntax
Plug 'scrooloose/syntastic'
let g:syntastic_javascript_checkers = ['eslint']

Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --gocode-completer' }

" Plugins - Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0

" Plugins - Purescript
Plug 'raichoo/purescript-vim'

" Plugins - Markdown
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()

" Colors
colorscheme base16-eighties
set background=dark
highlight clear SignColumn

" Visuals
set cursorline

" Lazy redrawing of buffer (helps with an influx of actions)
set lazyredraw

" Shows what you are typing as a command
set showcmd

" Syntax and indentation
syntax enable
set autoindent
filetype plugin indent on

" Tabs and indentation
set tabstop=4     " visual width of tab character
set shiftwidth=4  " automatic indentation and '>>' shortcut
" set softtabstop=tabstop (by default) " amount of spaces to use in expanded tabs

set expandtab     " use spaces instead of tabs
set shiftround    " round indent to nearest shiftwidth multiple

set autoindent    " copy indentation from previous line
" set smartindent " non-filetype based indentation scheme

" Line break on ' ^I!@*-+;:,./?' instead of within words
set linebreak

" Command autocompletion
set wildmenu
set wildmode=list:longest,full

" Mouse support
set mouse=a

" Line numbers
set number

" Search - case-sensitivity
set ignorecase
set smartcase

" Search - show immediate results and highlight
set incsearch
set hlsearch

" Store backups in ~/.vim
set backup
set backupdir=~/.nvim/backup
set directory=~/.nvim/tmp

" Enter directory of file
set autochdir
