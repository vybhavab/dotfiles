return {
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		config = function()

      vim.g.tokyonight_style = "night"
      vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}
      vim.g.tokyonight_transparent_sidebar = true
      vim.g.tokyonight_transparent = true
      vim.opt.background = "dark"
      vim.cmd("colorscheme tokyonight")

      local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
      end

      hl("SignColumn", {
        bg = "none",
      })

      hl("ColorColumn", {
        ctermbg = 0,
        bg = "#2B79A0",
      })

      hl("CursorLineNR", {
        bg = "None"
      })

      hl("Normal", {
        bg = "none"
      })

      hl("LineNr", {
        fg = "#5eacd3"
      })

      hl("netrwDir", {
        fg = "#5eacd3"
      })

		end,
	}
}
