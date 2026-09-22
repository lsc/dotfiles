return {
  { "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-ui" },
  { "kristijanhusak/vim-dadbod-completion" },
  {
    "2giosangmitom/sqmeow.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    version = "*",
    build = function()
      -- Downloads the matching release binary; pass 'curl', 'wget', 'powershell' or 'cargo' to choose.
      require("sqmeow").install()
    end,
    opts = {},
    cmd = "Sqmeow",
    keys = {
      { "<leader>Dd", "<cmd>Sqmeow toggle<cr>", desc = "Toggle" },
      { "<leader>Dc", "<cmd>Sqmeow cancel<cr>", desc = "Cancel" },
      { "<leader>Da", "<cmd>Sqmeow add<cr>", desc = "Add Connection" },
      { "<leader>Ds", "<cmd>Sqmeow scratch<cr>", desc = "New Scratchpad" },
    },
  },
}
