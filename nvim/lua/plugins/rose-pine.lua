
-- ~/.config/nvim/lua/plugins/rose-pine.lua
return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000, -- optional: makes sure it's loaded early
  config = function()
    vim.cmd("colorscheme rose-pine")
  end,
}

