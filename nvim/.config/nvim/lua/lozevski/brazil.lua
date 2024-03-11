local U = require("lozevski.utils")

local M = { cache = {} }

-- main functions

function M.brazil_path(recipe, cmd_opts)
  local single_recipe = type(recipe) == "string"
  local recipes = single_recipe and { recipe } or recipe
  local uncalculated = {}
  for _, r in ipairs(recipes) do
    if not M.get_cached_value("/bp." .. r) then
      table.insert(uncalculated, r)
    end
  end
  if #uncalculated > 0 then
    local cmd_string = "brazil-path --format=json " .. table.concat(uncalculated, " ")
    vim.notify("Running " .. cmd_string)
    local cmd_result = U.run_command(cmd_string, cmd_opts)
    if cmd_result.return_code ~= 0 then
      print("FAILED: " .. cmd_string .. ", " .. cmd_result.stderr)
      return nil
    end
    local new_paths = vim.fn.json_decode(cmd_result.stdout)
    for r, result in pairs(new_paths) do
      M.cache_value("bp." .. r, result)
    end
  end
  local calculated = {}
  for _, r in ipairs(recipes) do
    calculated[r] = M.get_cached_value("/bp." .. r)
  end
  if single_recipe then
    return calculated[recipe]
  end
  return calculated
end

function M.workspace_info()
  if not M.in_workspace() then
    return nil
  end
  return vim.fn.json_decode(M.get_or_init_cached_value("workspace.info.json", function()
    return U.run_command("brazil ws show --format=json").stdout
  end, { workspace = true }))
end

function M.get_or_init_cached_value(key, initializer, opts)
  local location = M.cache_location(key, opts)
  if not U.exists(location) then
    if type(initializer) == "string" then
      M.cache_value(key, initializer, opts)
    else
      M.cache_value(key, initializer(), opts)
    end
  end
  return M.get_cached_value(key, opts)
end

function M.package_name()
  local config = vim.fs.find({ "Config" }, { upward = true, type = "file" })[1]
  if config then
    return vim.fs.basename(vim.fs.dirname(config))
  end
  return nil
end

function M.package_roots()
  local info = M.workspace_info()
  if info == nil then
    return {}
  end
  local roots = {}
  for _, package in ipairs(info.packages or {}) do
    table.insert(roots, package.source_location)
  end
  return roots
end

function M.workspace_root()
  if not M.in_workspace() then
    return nil
  end
  return M.workspace_info()["root"]
end

function M.bemol_workspace_directories()
  local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
  local ws_folders_lsp = {}
  if bemol_dir then
    local file = io.open(bemol_dir .. "/ws_root_folders", "r")
    if file then
      for package_root in file:lines() do
        if U.exists(package_root) then
          table.insert(ws_folders_lsp, package_root)
        end
      end
      file:close()
    end
  end
  return ws_folders_lsp
end

function M.add_bemol_roots()
  -- this is the equivelent of
  -- https://w.amazon.com/bin/view/Bemol#HnvimbuiltinLSP28withlsp-configand2Forlsp-zero29
  for _, package_root in ipairs(M.bemol_workspace_directories()) do
    if not vim.tbl_contains(vim.lsp.buf.list_workspace_folders(), package_root) then
      vim.lsp.buf.add_workspace_folder(package_root)
    end
  end
end

-- internal functions

function M.package_info()
  return vim.fs.find({ "packageInfo" }, { upward = true, type = "file" })[1]
end

function M.package_config()
  return vim.fs.find({ "Config" }, { upward = true, type = "file" })[1]
end

function M.in_workspace()
  return M.package_info() ~= nil
end

function M.nvim_ws_cache_path()
  if not M.in_workspace() then
    return nil
  end
  if M.cache.ws_version == nil then
    M.cache.ws_version = U.shasum(M.package_info())
  end
  return vim.fs.dirname(M.package_info()) .. "/.neovim/" .. M.cache.ws_version
end

function M.nvim_pkg_cache_path()
  local path = M.nvim_ws_cache_path() .. "/" .. M.package_name()
  if not U.exists(path) then
    U.run_command("mkdir -p " .. path)
  end
  return path
end

function M.cache_location(key, opts)
  if opts and opts.workspace then
    return M.nvim_ws_cache_path() .. "/" .. key
  end
  return M.nvim_pkg_cache_path() .. "/" .. key
end

function M.cache_value(key, content, opts)
  local cache_location = M.cache_location(key, opts)
  if not U.exists(vim.fs.dirname(cache_location)) then
    U.run_command("mkdir -p " .. vim.fs.dirname(cache_location))
  end
  U.write_file(cache_location, content)
end

function M.get_cached_value(key, opts)
  local cache_location = M.cache_location(key, opts)
  if not U.exists(cache_location) then
    return nil
  end
  return U.read_file(cache_location)
end

function M.package_target_types()
  local types = {}
  local config_file = M.package_config()
  if config_file == nil then
    return types
  end
  local config_data = U.read_file(config_file)
  for target in string.gmatch(config_data, "type%s*=%s*(%w+)%s*;") do
    types[target] = true
  end
  return types
end

return M
