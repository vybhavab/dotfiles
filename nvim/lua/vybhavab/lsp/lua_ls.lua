return {
  cmd = { vim.fn.exepath('lua-language-server') or 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      diagnostics = {
        globals = { "vim" }
      }
    }
  }
}
