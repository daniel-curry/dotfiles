return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
  config = function()
    require("nvim-tree").setup({
      hijack_cursor = true,
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      view = {
        width = 30,
        side = "left",
        preserve_window_proportions = true,
      },
      renderer = {
        highlight_git = true,
        highlight_opened_files = "all",
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
    })

    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File Tree" })
    vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFocus<cr>",  { desc = "Focus File Tree" })
  end,
}

