local function packer_verify()
    local cmd = vim.api.nvim_command
    local fn = vim.fn

    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', 'git clone https://github.com/wbthomason/packer.nvim', install_path})
        cmd 'packadd packer.nvim'
    end
end

local function packer_startup()
    require('packer').startup(function(use)
        -- Packer
        use 'wbthomason/packer.nvim'

        -- LSP
        use 'neovim/nvim-lspconfig'
        use {
            'kabouzeid/nvim-lspinstall',
            requires = { 'neovim/nvim-lspconfig' }
        }
        use {
            'hrsh7th/nvim-compe',
            requires = { 'neovim/nvim-lspconfig' }
        }
        use {
            'hrsh7th/vim-vsnip',
            requires = { 'neovim/nvim-compe' }
        }
        use {
            'nvim-treesitter/nvim-treesitter',
            requires = { 'neovim/nvim-lspconfig' },
            run = ":TSUpdate"
        }

        -- Telescope
        use 'nvim-lua/plenary.nvim'
        use 'nvim-lua/popup.nvim'
        use {
            'nvim-telescope/telescope-fzy-native.nvim',
            requires = {
                'nvim-lua/plenary.nvim',
                'nvim-lua/popup.nvim',
                'nvim-telescope/telescope.nvim'
            }
        }
        use {
            'nvim-telescope/telescope.nvim',
            requires = {
                'nvim-lua/plenary.nvim',
                'nvim-lua/popup.nvim'
            }
        }


        -- Colors
        use 'folke/tokyonight.nvim'
        -- use 'yashguptaz/calvera-dark.nvim'
        use 'luochen1990/rainbow'

        -- Utils
        use {
            'ThePrimeagen/harpoon',
            requires = {
                'nvim-lua/plenary.nvim'
            }
        }

        use 'hoob3rt/lualine.nvim'
        use 'romgrk/nvim-treesitter-context'
        use 'kyazdani42/nvim-web-devicons'
        use 'simrat39/symbols-outline.nvim'

        use 'voldikss/vim-floaterm'

        use {
            'lewis6991/gitsigns.nvim',
            requires = {
                'nvim-lua/plenary.nvim'
            }
        }

        use 'jose-elias-alvarez/null-ls.nvim'

        use {
            'jose-elias-alvarez/nvim-lsp-ts-utils',
            requires = {
                'neovim/nvim-lspconfig',
                'jose-elias-alvarez/null-ls.nvim',
                'nvim-lua/plenary.nvim'
            }
        }

        use {
          "ray-x/lsp_signature.nvim",
        }


    end)
end

local function init()
  packer_verify()
  packer_startup()
end

return {
  init = init
}
