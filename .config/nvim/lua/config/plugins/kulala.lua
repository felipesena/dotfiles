return {
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    opts = {},
    keys = {
      {
        "<leader>rr",
        function()
          require("kulala").run()
        end,
        desc = "REST: run request",
      },
      {
        "<leader>rt",
        function()
          require("kulala").toggle_view()
        end,
        desc = "REST: toggle request/response view",
      },
    },
  },
}
