local hl = function(thing, opts)
    vim.api.nvim_set_hl(0, thing, opts)
end

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
        bg = "#555555",
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

local function catppuccin()
  local catppuccin = require("catppuccin")

  catppuccin.setup(
      {
      transparent_background = false,
      term_colors = false,
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
          virtual_text = {
            errors = "italic",
            hints = "italic",
            warnings = "italic",
            information = "italic",
          },
          underlines = {
            errors = "underline",
            hints = "underline",
            warnings = "underline",
            information = "underline",
          },
        },
        lsp_trouble = false,
        lsp_saga = false,
        gitgutter = true,
        gitsigns = true,
        telescope = true,
        nvimtree = {
          enabled = false,
          show_root = false,
        },
        which_key = false,
        indent_blankline = {
          enabled = false,
          colored_indent_levels = false,
        },
        dashboard = false,
        neogit = false,
        vim_sneak = false,
        fern = false,
        barbar = false,
        bufferline = false,
        markdown = false,
        lightspeed = false,
        ts_rainbow = false,
        hop = false,
      },
    }
  )

  vim.cmd[[colorscheme catppuccin]]

end

local function ayu()
  local ayu_theme = require("ayu")
  ayu_theme.setup({
    mirage = false,
    overrides = {}
  })

  ayu_theme.colorscheme()
end

local function kanagawa()
  local default_colors = require('kanagawa.colors')
  require('kanagawa').setup({
    undercurl = true,
    commentStyle = "italic",
    functionStyle = "NONE",
    keywordStyle = "italic",
    statementStyle = "bold",
    typeStyle = "NONE",
    variablebuiltinStyle = "italic",
    specialReturn = true,       -- special highlight for the return keyword
    specialException = true,    -- special highlight for exception handling keywords
    transparent = false,        -- do not set background color
    colors = {},
    overrides = {
      ColorColumn = {
        bg = default_colors.bg_dark
      }
    }
  })

  vim.cmd[[colorscheme kanagawa]]
end

return {
    init = tokyonight
}
