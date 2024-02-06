return {
	{
		"hoob3rt/lualine.nvim",
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
	},
}
