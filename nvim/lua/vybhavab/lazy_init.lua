local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("vybhavab.lazy")

--[[
require("lazy").setup({
	'nvim-telescope/telescope.nvim',
	{
		'nvim-treesitter/nvim-treesitter',
		build = ":TSUpdate",
	},
	"nvim-treesitter/playground",
	"theprimeagen/harpoon",
	"theprimeagen/refactoring.nvim",
	"mbbill/undotree",
	"tpope/vim-fugitive",
	"nvim-treesitter/nvim-treesitter-context",
	'VonHeikemen/lsp-zero.nvim',
	'sbdchd/neoformat',
	"folke/zen-mode.nvim",
	'kyazdani42/nvim-web-devicons',
	'kdheepak/lazygit.nvim',
	'lewis6991/gitsigns.nvim',
}, {})
--]]
