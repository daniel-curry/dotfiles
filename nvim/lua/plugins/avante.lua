return {
  "yetone/avante.nvim",
  build = function()
    if vim.fn.has("win32") == 1 then
      return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    else
      return "make"
    end
  end,
  event   = "VeryLazy",
  version = false,

    opts = {
    mode    = "agentic",
    provider  = "claude",
    providers = {
      claude = {
        endpoint      = "https://api.anthropic.com",
        model         = "claude-sonnet-4-20250514",
        timeout       = 30000,
        disable_tools = false,
        extra_request_body = {
          temperature = 0.75,
          max_tokens  = 20480,
        },
      },
    },
  },

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "stevearc/dressing.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft   = { "markdown", "Avante" },
    },
  },
}

