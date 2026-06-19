hl.config({

    general = { 
        gaps_in = 0,
        gaps_out = 0,
        border_size = 2,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",

        col = {
            active_border = "rgb(162, 161, 161)",
            inactive_border = "rgb(0 ,0, 0)"
        }
    },

    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        blur = { enabled = false }
    },

    animations = { enabled = true },
    dwindle = { preserve_split = true },

    misc = {
        force_default_wallpaper = false,
        disable_hyprland_logo = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true
    },

    xwayland = {
        enabled = true,
        force_zero_scaling = true
    }
})

local curves = {
  gentle = { type = "bezier", points = { {0.1, 0.8}, {0.1, 1.0} } },
  snap   = { type = "bezier", points = { {0.0, 1.0}, {0.0, 1.0} } },
}

for name, spec in pairs(curves) do
  hl.curve(name, spec)
end

local animations = {
  { leaf = "windows",          speed = 1.5, bezier = "gentle" },
  { leaf = "windowsOut",       speed = 1.5, bezier = "gentle" },
  { leaf = "fade",             speed = 2,   bezier = "gentle" },
  { leaf = "workspaces",       speed = 2,   bezier = "snap" },
  { leaf = "specialWorkspace", speed = 3,   bezier = "gentle", style = "slidefade 0%" },
  { leaf = "border",           speed = 2,   bezier = "gentle" },
}

for _, a in ipairs(animations) do
  if a.enabled == nil then a.enabled = true end
  hl.animation(a)
end

-- Smart gaps
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })

hl.window_rule({
    name  = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})

hl.window_rule({
    name  = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})

hl.window_rule({
    name = "no-border-scout",
    match = { class = "scout" },
    border_size = 0
})
