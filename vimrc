set number
"set nu rnu
set showcmd
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set smarttab
set autoindent
set noerrorbells
set vb t_vb=
set so=5

set clipboard+=unnamedplus

set splitbelow
set mouse=a

set encoding=UTF-8

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline' 
Plug 'vim-airline/vim-airline-themes' 
Plug 'dylanaraps/wal.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
Plug 'preservim/nerdtree'
Plug 'roxma/nvim-yarp'
Plug 'gaalcaras/ncm-R'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'akinsho/bufferline.nvim'
"Plug 'jiangmiao/auto-pairs'
Plug 'preservim/tagbar'
Plug 'jupyter-vim/jupyter-vim'
Plug 'kyazdani42/nvim-tree.lua'
 

" run last
"Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
call plug#end()

" draw colorscheme from pywal
colorscheme wal

" Better searching
set incsearch
set ignorecase
set smartcase

" split prio
set splitright splitbelow

" set :Q to quit
command! Q q
" set :W to save
command! W w

" Set leader to comma
let mapleader = ","

" set ; to :
nnoremap ; :

" COC autocomplete settings
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Airline settings
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'

set guifont=DroidSansMono\ Nerd\ Font\ 12

let g:airline_left_sep = "\uE0B5"
let g:airline_left_sep = "\uE0B4"
let g:airline_right_sep = "\uE0B7"
let g:airline_right_sep = "\uE0B6"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = "\uE0B4"
let g:airline#extensions#tabline#left_alt_sep = "\uE0B5"
let g:airline#extensions#tabline#formatter = 'unique_tail'

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" NerdTree settings
" let NERDTreeShowHidden = 1
let NERDTreeShowLineNumbers = 0
let NERDTreeShowBookmarks = 1
nmap <C-Y> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=23

" Tagbar Settings
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_position = 'botright vertical'
nmap <C-P> :TagbarToggle<CR>

" buffer keybinds
nmap <leader>T :enew<CR>
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>bq :bp <BAR> bd #<CR>

"" buferline settings
" set termguicolors
lua << EOF
require("bufferline").setup{}
EOF
