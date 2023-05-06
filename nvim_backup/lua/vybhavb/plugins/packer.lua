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
            'williamboman/nvim-lsp-installer',
            requires = { 'neovim/nvim-lspconfig' }
        }
        use 'sbdchd/neoformat'
        use 'nvim-lua/lsp_extensions.nvim'

        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'

        use {
          'tzachar/cmp-tabnine',
          run='./install.sh',
          requires = {
            'hrsh7th/nvim-cmp'
          }
        }


        -- use 'github/copilot.vim'

        -- use {
        --   'zbirenbaum/copilot-cmp',
        --   module = "copilot_cmp",
        --   requires = {
        --     'hrsh7th/nvim-cmp',
        --     'zbirenbaum/copilot.lua'
        --   }
        -- }

        -- use {
        --   'zbirenbaum/copilot.lua',
        --   event = {"VimEnter"},
        --   config = function()
        --     vim.defer_fn(function()
        --       require("copilot").setup()
        --     end, 100)
        --   end,
        --   requires = {
        --     'hrsh7th/nvim-cmp',
        --     'github/copilot.vim'
        --   }
        -- }

        use 'onsails/lspkind-nvim'

        use 'saadparwaiz1/cmp_luasnip'
        use 'L3MON4D3/LuaSnip'

        use {
            'nvim-treesitter/nvim-treesitter',
            requires = { 'neovim/nvim-lspconfig' },
            run = ':TSUpdate'
        }

        use {
          'ThePrimeagen/git-worktree.nvim',
          requires = {
            'nvim-lua/plenary.nvim',
            'nvim-lua/popup.nvim',
            'nvim-telescope/telescope.nvim',
            'hoob3rt/lualine.nvim'
          }
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

        use 'nvim-telescope/telescope.nvim'

        -- Colors
        use 'folke/tokyonight.nvim'

        use 'Shatur/neovim-ayu'
        use 'rebelot/kanagawa.nvim'
        use 'luochen1990/rainbow'
        use({
          "catppuccin/nvim",
          as = "catppuccin"
        })

        -- Utils
        use {
            'ThePrimeagen/harpoon',
            requires = {
                'nvim-lua/plenary.nvim'
            }
        }

        use {
          "folke/zen-mode.nvim",
          config = function()
            require("zen-mode").setup {
              width = 130
            }
          end,
        }

        use 'hoob3rt/lualine.nvim'
        use {
          'nvim-treesitter/nvim-treesitter-context',
          requires = {
            'nvim-treesitter/nvim-treesitter',
          }
        }
        use 'kyazdani42/nvim-web-devicons'
        use 'simrat39/symbols-outline.nvim'

        -- use 'voldikss/vim-floaterm'
        use 'kdheepak/lazygit.nvim'

        use {
            'lewis6991/gitsigns.nvim',
            requires = {
                'nvim-lua/plenary.nvim'
            }
        }

        use {
           'tpope/vim-fugitive'
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
            'ray-x/lsp_signature.nvim',
        }

        use {
            'lazytanuki/nvim-mapper',
        }

        use {
            'glacambre/firenvim',
            run = function() vim.fn['firenvim#install'](0) end
        }

        -- Debugging
        use {
            'mfussenegger/nvim-dap'
        }

        use {
            "rcarriga/nvim-dap-ui",
            requires = {
              "mfussenegger/nvim-dap"
            }
        }

        use {
            "mbbill/undotree"
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
