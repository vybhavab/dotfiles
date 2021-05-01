" Thanks to https://github.com/awesome-streamers/awesome-streamerrc
" for most of this vimrc help

set path+=**
set wildmode=longest,list,full
set wildmenu
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

" To install vim plug if it isn't already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
"LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'glepnir/lspsaga.nvim'
Plug 'kabouzeid/nvim-lspinstall'
" Plug 'nvim-lua/completion-nvim'
" Plug 'tjdevries/nlua.nvim'
" Plug 'tjdevries/lsp_extensions.nvim'

"Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Debugging stuff
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'


Plug 'simrat39/symbols-outline.nvim'

Plug 'mbbill/undotree'

" Colors
Plug 'flazz/vim-colorschemes'
Plug 'folke/tokyonight.nvim'
Plug 'luochen1990/rainbow'

Plug 'tpope/vim-fugitive'

Plug 'voldikss/vim-floaterm'

" Harpoon
Plug 'ThePrimeagen/harpoon'

" LuaLine
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

call plug#end()


" ======= COLORS ============
" colorscheme
" let ayucolor='dark'
" hi SignColumn guibg=none
" highlight Normal guibg=none
" highlight LineNr guifg=#4c84a1
" highlight netrwDir guifg=#5eacd3
" highlight TelescopeBorder guifg=#5eacd

let g:tokyonight_style = "night"
colorscheme tokyonight
"highlight ColorColumn ctermbg=0 guibg=grey
"hi SignColumn guibg=none
highlight Normal guibg=none
highlight LineNr guifg=#a9b1d6
highlight CursorLineNr guifg=#7aa2f7
highlight netrwDir guifg=#7dcfff
highlight TelescopeBorder guifg=#7dcfff
highlight link CompeDocumentation NormalFloat

" ======= LUA ==============
lua require("vybhavb")
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

let mapleader=" "

" ======= REMAPS ===========

" Resize splits
nnoremap <silent> <leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" edit/reload vimrc
nmap <leader>ev :e $MYVIMRC<CR>
nmap <leader>sv :so $MYVIMRC<CR>

" better ESC
inoremap jj <esc>

" fast save and close
nmap <leader>w :w<CR>
nmap <leader>x :x<CR>
nmap <leader>q :q<CR>

nnoremap <leader>pv :Ex<CR>
vnoremap <leader>p "_dP
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap <leader>d "_d
vnoremap <leader>d "_d



function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

augroup vybhavb
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
