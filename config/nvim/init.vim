call plug#begin('~/.local/share/nvim/plugged')
Plug 'davidhalter/jedi-vim'
Plug 'ayu-theme/ayu-vim'
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-gitgutter'
Plug 'lervag/vimtex'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --ts-completer --java-completer ' }
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'shime/vim-livedown'
Plug 'w0rp/ale'

call plug#end()

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

set termguicolors     " enable true colors support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax enable

let ayucolor='dark'   " for dark version of theme
colorscheme ayu

set tabstop=2      " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set shiftwidth=2    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line

set number                   " show line number
set showcmd                  " show command in bottom bar
set cursorline               " highlight current line
set wildmenu                 " visual autocomplete for command menu
set showmatch                " highlight matching brace
set laststatus=2             " window will always have a status line
set nobackup
set noswapfile
let &colorcolumn="100,".join(range(119,999),",")

set foldenable
set foldlevelstart=10  " default folding level when buffer is opened
set foldnestmax=10     " maximum nested fold
set foldmethod=syntax  " fold based on indentation

" edit/reload vimrc
nmap <leader>ev :e $MYVIMRC<CR>
nmap <leader>sv :so $MYVIMRC<CR>

" better ESC
inoremap jj <esc>

" fast save and close
nmap <leader>w :w<CR>
nmap <leader>x :x<CR>
nmap <leader>q :q<CR>


" YCM mappings {{{
nnoremap <leader>g :YcmCompleter GoTo<CR>
" }}}

" YCM {{{
"let g:ycm_server_keep_logfiles = 1
"let g:ycm_server_log_level = 'debug'
let g:ycm_filetype_specific_completion_to_disable = {
    \ 'gitcommit': 1,
    \ 'python': 1
    \}
let g:ycm_rust_src_path='/home/synasius/workspace/rust/src/'
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's

" }}}

map <C-n> :NERDTreeToggle<CR>


" move up/down consider wrapped lines
nnoremap j gj
nnoremap k gk

"nerd tree
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__','/node_modules']

" IndentLine {{
let g:indentLine_char = ''
let g:indentLine_first_char = ''
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 0
" }}


