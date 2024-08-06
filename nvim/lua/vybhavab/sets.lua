vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_localrmdir = 'rm -rd'

local settings = {
    errorbells = false,
    exrc = true,
    hidden=true,
    showmode=false,
    completeopt="menu,menuone,noselect",
    encoding="utf8",
    secure=true,
    splitright=true,
    splitbelow=true,
    updatetime=300
}

-- Generic vim.o
for k, v in pairs(settings) do
	vim.o[k] = v
end

-- Custom vim.o
vim.o.shortmess = vim.o.shortmess .. 'c'
-- vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
