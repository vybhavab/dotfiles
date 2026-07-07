local M = {}

local dependency_fields = {
  "dependencies",
  "devDependencies",
  "optionalDependencies",
  "peerDependencies",
}

function M.find_local_bin(root_dir, bin)
  local dir = root_dir

  while dir and dir ~= "" do
    local candidate = vim.fs.joinpath(dir, "node_modules", ".bin", bin)
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end

    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  return nil
end

function M.read_package_json(dir)
  local file = io.open(vim.fs.joinpath(dir, "package.json"), "r")
  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()

  local ok, json = pcall(vim.json.decode, content)
  if not ok or type(json) ~= "table" then
    return nil
  end

  return json
end

function M.has_dependency_matching(package_json, matcher)
  for _, field in ipairs(dependency_fields) do
    local dependencies = package_json[field]
    if type(dependencies) == "table" then
      for name, version in pairs(dependencies) do
        if matcher(name, version) then
          return true
        end
      end
    end
  end

  return false
end

return M
