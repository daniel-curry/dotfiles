
return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      

"███╗   ██╗██╗   ██╗██╗███╗   ███╗",
"████╗  ██║██║   ██║██║████╗ ████║",
"██╔██╗ ██║██║   ██║██║██╔████╔██║",
"██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
"██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
"╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
                                 
    }

    dashboard.section.buttons.val = {
      dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "  Recent", ":Telescope oldfiles<CR>"),
      dashboard.button("t", "  Toggle terminal", ":ToggleTerm<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }


    alpha.setup(dashboard.config)
  end
}

