local function init()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = { "cpp", "lua", "javascript", "typescript", "css", "cpp" },
      auto_install = true,
      highlight = {
        enable = true
      },
      indent = {
        enable = true
      }
    }

    require'treesitter-context'.setup{
      enable = true,
      max_lines = 0,
      trim_scope = 'outer',
      patterns = {
          default = {
              'class',
              'function',
              'method',
              'if',
          },
      },
      zindex = 20, -- The Z-index of the context window
      mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
      separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
    }
end

return {
    init = init
}
