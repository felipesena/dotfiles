-- Starts jdtls per-project (one workspace dir per root) and wires up
-- java-debug-adapter/java-test so nvim-dap and neotest-java can run/debug
-- JUnit tests and app main classes. Mirrors what mason-lspconfig does
-- automatically for the other servers in lua/config/plugins/lsp.lua,
-- but jdtls needs its bundles/workspace set up manually.

local jdtls = require("jdtls")
local mason_registry = require("mason-registry")

local root_dir = require("jdtls.setup").find_root({ "gradlew", "mvnw", ".git" })
if not root_dir then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()

local bundles = {}
if mason_registry.is_installed("java-debug-adapter") then
  local debug_path = mason_registry.get_package("java-debug-adapter"):get_install_path()
  vim.list_extend(
    bundles,
    vim.split(vim.fn.glob(debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
  )
end
if mason_registry.is_installed("java-test") then
  local test_path = mason_registry.get_package("java-test"):get_install_path()
  vim.list_extend(bundles, vim.split(vim.fn.glob(test_path .. "/extension/server/*.jar"), "\n"))
end

local capabilities = require("blink.cmp").get_lsp_capabilities()

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    jdtls_path .. "/config_linux",
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = { favoriteStaticMembers = {} },
    },
  },
  init_options = {
    bundles = bundles,
  },
}

jdtls.start_or_attach(config)
require("jdtls.dap").setup_dap_main_class_configs()

vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { buffer = 0, desc = "Java: organize imports" })
vim.keymap.set("n", "<leader>jt", jdtls.test_class, { buffer = 0, desc = "Java: run test class" })
vim.keymap.set("n", "<leader>jn", jdtls.test_nearest_method, { buffer = 0, desc = "Java: run nearest test" })
