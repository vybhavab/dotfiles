local typescript = require("vybhavab.lsp.typescript")

return {
  init_options = {
    preferences = {
      importModuleSpecifierPreference = 'non-relative',
      importModuleSpecifier = 'non-relative', -- TS <5.2 uses this
    },
  },
  root_dir = function(bufnr, on_dir)
    local project_root = typescript.root_dir(bufnr)

    if not typescript.uses_native_preview(project_root) then
      on_dir(project_root)
    end
  end,
}
