-- Auto-populate new Java/Kotlin files with package + class boilerplate,
-- similar to IntelliJ's "New Class" scaffolding.

local function package_from_path(filepath)
  local dir = vim.fn.fnamemodify(filepath, ":p:h")
  local root = dir:match("(.*/src/[^/]+/[^/]+)")
  if not root then
    return nil
  end

  local pkg_path = dir:sub(#root + 2)
  if pkg_path == "" then
    return nil
  end

  return (pkg_path:gsub("/", "."))
end

local function class_name(filepath)
  return vim.fn.fnamemodify(filepath, ":t:r")
end

local function insert_boilerplate(package_line, class_decl)
  local filepath = vim.api.nvim_buf_get_name(0)
  local pkg = package_from_path(filepath)
  local name = class_name(filepath)

  local lines = {}
  if pkg then
    table.insert(lines, package_line(pkg))
    table.insert(lines, "")
  end
  table.insert(lines, class_decl(name))
  table.insert(lines, "")
  table.insert(lines, "}")

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, { #lines - 1, 0 })
  vim.cmd("startinsert!")
end

local group = vim.api.nvim_create_augroup("new-file-boilerplate", { clear = true })

vim.api.nvim_create_autocmd("BufNewFile", {
  group = group,
  pattern = "*.java",
  callback = function()
    insert_boilerplate(function(pkg)
      return "package " .. pkg .. ";"
    end, function(name)
      return "public class " .. name .. " {"
    end)
  end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  group = group,
  pattern = "*.kt",
  callback = function()
    insert_boilerplate(function(pkg)
      return "package " .. pkg
    end, function(name)
      return "class " .. name .. " {"
    end)
  end,
})
