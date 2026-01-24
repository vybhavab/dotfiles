return {
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'tsconfig.json', 'package.json', 'pnpm-workspace.yaml', '.git' }
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,
}
