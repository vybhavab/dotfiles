local node = require("vybhavab.utils.node")

local M = {}

local root_markers = { "tsconfig.json", "jsconfig.json", "package.json", "pnpm-workspace.yaml", ".git" }

local function is_native_preview_dependency(name, version)
  if name == "@typescript/native-preview" or name == "typescript-go" then
    return true
  end

  if type(version) ~= "string" then
    return false
  end

  return version:find("@typescript/native-preview", 1, true) ~= nil or version:find("typescript-go", 1, true) ~= nil
end

function M.root_dir(bufnr)
  return vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
end

function M.uses_native_preview(root_dir)
  local dir = root_dir

  while dir and dir ~= "" do
    local package_json = node.read_package_json(dir)
    if package_json and node.has_dependency_matching(package_json, is_native_preview_dependency) then
      return true
    end

    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  return false
end

return M
