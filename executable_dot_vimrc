syntax on

set nocompatible
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set smartcase
set wrap
set noswapfile
set incsearch
set hlsearch

call plug#begin()
    " NerdTree
    Plug 'preservim/nerdtree'
    " Automatically close parenthesis, etc
    Plug 'Townk/vim-autoclose'
    " Stylish line for vim 
    Plug 'vim-airline/vim-airline'
    Plug 'ryanoasis/vim-devicons'
    " Autocomplete for many languages
    " Plug 'valloric/youcompleteme'
    " Typescript Completion
    " Plug 'quramy/tsuquyomi'
    " Emmet for Vim
    " Plug 'mattn/emmet-vim'
call plug#end()

" NerdTree
autocmd VimEnter * NERDTree | wincmd p
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
autocmd BufWinEnter * silent NERDTreeMirror
nnoremap <C-a> :NERDTreeToggle<CR>
" NerdTree
