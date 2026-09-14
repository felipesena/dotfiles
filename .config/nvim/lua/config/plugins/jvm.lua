return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- Kotlin debugging. Java is wired per-project by nvim-jdtls itself,
      -- see after/ftplugin/java.lua.
      local mason_registry = require("mason-registry")
      if mason_registry.is_installed("kotlin-debug-adapter") then
        local install_path = mason_registry.get_package("kotlin-debug-adapter"):get_install_path()

        dap.adapters.kotlin = {
          type = "executable",
          command = install_path .. "/adapter/bin/kotlin-debug-adapter",
        }
        dap.configurations.kotlin = {
          {
            type = "kotlin",
            request = "launch",
            name = "Launch",
            mainClass = function()
              return vim.fn.input("Main class (FQN): ")
            end,
          },
        }
      end

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: step into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: step over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: step out" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: toggle UI" })
    end,
  },
}
