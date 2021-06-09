local function set_augroups()
end

local function set_keymaps()
    local map = vim.api.nvim_set_keymap
    
    local options = { noremap = false }
    
    map('n', '<leader>h', '<CMD>wincmd h<CR>', options)
    map('n', '<leader>j', '<CMD>wincmd j<CR>', options)
    map('n', '<leader>k', '<CMD>wincmd k<CR>', options)
    map('n', '<leader>l', '<CMD>wincmd l<CR>', options)
    map('n', '<leader>tp', '<CMD>tabp<CR>', options)
    map('n','<leader>tn', '<CMD>tabn<CR>', options)
    map('n','<leader>nt', '<CMD>tabnew<CR>',options)

    map('n','<silent> <leader>+', '<CMD>exe "resize " . (winheight(0) * 3/2)<CR>',options)
    map('n','<silent> <leader>-', '<CMD>exe "resize " . (winheight(0) * 2/3)<CR>', options)

    map('n', '<leader>w', '<CMD>w<CR>', options)
    map('n', '<leader>x', '<CMD>x<CR>',options)
    map('n', '<leader>q','<CMD>q<CR>',options)

    map('n','<leader>pv', '<CMD>Ex<CR>',options)
    --map('v','<leader>p' '"_dP',
    --map('n','<leader>y "+y
    --map('v','<leader>y "+y
    --map('n','<leader>Y gg"+yG

    --map('n','<leader>d "_d
    --map('v','<leader>d "_d


end

local function set_vim_g()
    vim.g.mapleader = " "
    vim.g.netrw_browse_split = 0
    vim.g.netrw_banner = 0
    vim.g.netrw_winsize = 25
    vim.g.netrw_localrmdir = 'rm -r'
end

local function set_vim_o()
    local settings = {
        errorbells = false,
        expandtab = true,
        softtabstop=4,
        exrc = true,
        hlsearch=false,
        smartindent=true,
        hidden=true,
        termguicolors=true,
        swapfile=false,
        backup=false,
        undodir="/Users/vybhavb/.vim/undodir",
        undofile=true,
        incsearch=true,
        scrolloff=10,
        showmode=false,
        completeopt="menuone,noinsert,noselect",
        signcolumn="yes",
        colorcolumn="120"
    }

    -- Generic vim.o
    for k, v in pairs(settings) do
      vim.o[k] = v
    end

    -- Custom vim.o
    vim.o.shortmess = vim.o.shortmess .. 'c'
    
    vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'

    -- Not yet in vim.o
    vim.cmd('set encoding=utf8')
    vim.cmd('set shiftwidth=4')
    vim.cmd('set secure')
    vim.cmd('set splitright')
    vim.cmd('set splitbelow')
    vim.cmd('set tabstop=4')
    vim.cmd('set updatetime=300')

end

local function set_vim_wo()
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.wo.wrap = false
end

local function init()
    set_vim_g()
    set_vim_o()
    set_vim_wo()
    set_keymaps()
end


return {
    init = init
}