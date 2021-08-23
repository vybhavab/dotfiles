local function calvera()

  vim.g.calvera_italic_keywords = false
  vim.g.calvera_italic_comments = true
  vim.g.calvera_borders = true
  vim.g.calvera_contrast = true
  vim.g.calvera_hide_eob = false
  vim.g.calvera_custom_colors = {contrast = "#0f111a"}

  -- Required Setting
  require('calvera').set()

end

local function tokyonight()

    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_italic_functions = true
    vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}

    vim.cmd[[colorscheme tokyonight]]

end

local function catppuccino()
  local catppuccino = require("catppuccino")

  -- configure it
  catppuccino.setup(
      {
      colorscheme = "catppuccino",
      transparency = false,
      styles = {
        comments = "italic",
        functions = "italic",
        keywords = "italic",
        strings = "NONE",
        variables = "NONE",
      },
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          styles = {
            errors = "italic",
            hints = "italic",
            warnings = "italic",
            information = "italic"
          }
        },
        lsp_trouble = false,
        lsp_saga = false,
        gitgutter = false,
        gitsigns = true,
        telescope = true,
        nvimtree = false,
        which_key = false,
        indent_blankline = false,
        dashboard = false,
        neogit = false,
        vim_sneak = false,
        fern = false,
        barbar = false,
        bufferline = false,
        markdown = false,
      }
    }
  )

  -- load it
  catppuccino.load()
end

return {
    init = tokyonight
}
