-- Only required if you have packer configured as `opt`

local function packer_verify()
    local cmd = vim.api.nvim_command
    local fn = vim.fn

    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', 'git clone https://github.com/wbthomason/packer.nvim', install_path})
        cmd 'packadd packer.nvim'
    end
end

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

    use({"hoob3rt/lualine.nvim",
    config = function ()
        require'lualine'.setup {
            options = {
                icons_enabled = true,
                theme = 'palenight',
                component_separators = {'', ''},
                section_separators = {'', ''},
                disabled_filetypes = {}
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch'},
                lualine_c = {{'filename', path=1}},
                lualine_x = {'encoding', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {{'filename', path=1}},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            extensions = {}
        }
    end
})

	use({
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup {
				icons = true,
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	})

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}

	use("nvim-treesitter/playground")
	use("theprimeagen/harpoon")
	use("theprimeagen/refactoring.nvim")
	use("mbbill/undotree")
	use("tpope/vim-fugitive")
	use("nvim-treesitter/nvim-treesitter-context");

	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-nvim-lua'},

			-- Snippets
			{'L3MON4D3/LuaSnip'},
			{'rafamadriz/friendly-snippets'},
		}
	}

  use {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {enabled = false},
        panel = {enabled = false}
      })
    end,
  }

  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  }

	use 'sbdchd/neoformat'
	use("folke/zen-mode.nvim")

	use 'kyazdani42/nvim-web-devicons'
	use 'kdheepak/lazygit.nvim'

	use {
		'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
              current_line_blame = true,
            })
        end,
		requires = {
			'nvim-lua/plenary.nvim'
		}
	}
	-- Colors
	use 'folke/tokyonight.nvim'

	use 'Shatur/neovim-ayu'
	use 'rebelot/kanagawa.nvim'
	-- use 'luochen1990/rainbow'
	use({
		"catppuccin/nvim",
		as = "catppuccin"
	})

end)
