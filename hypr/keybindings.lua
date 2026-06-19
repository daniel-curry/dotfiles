local mainMod = "ALT"
local browser = "uwsm app -- zen-browser -new-window"
local exec = hl.dsp.exec_cmd

local mainMod_keybindings = {
    -- Programs
    { "RETURN",      exec("kitty") },
    { "B",           exec(browser) },
    { "SPACE",       exec("~/.cargo/bin/scout") },
    { "ESCAPE",      exec("hyprlock") },
    { "PRINT",       exec('grim -g "$(slurp)" - | wl-copy') },
    -- Web apps
    { "I",           exec(browser .. "=https://claude.ai") },
    { "T",           exec(browser .. "=https://app.todoist.com") },
    { "O",           exec(browser .. "=calendar.google.com") },
    -- System
    { "C",           hl.dsp.window.close() },
    { "V",           hl.dsp.window.float({ action = "toggle" }) },
    { "F",           hl.dsp.window.fullscreen({ action = "toggle" }) },
    { "SHIFT + N",   exec("swaync-client -t") },
    { "R",           hl.dsp.submap("resize") },
    -- Focus
    { "H",           hl.dsp.focus({ direction = "left" }) },
    { "J",           hl.dsp.focus({ direction = "down" }) },
    { "K",           hl.dsp.focus({ direction = "up" }) },
    { "L",           hl.dsp.focus({ direction = "right" }) },
    -- Move
    { "SHIFT + H",   hl.dsp.window.move({ direction = "l" }) },
    { "SHIFT + J",   hl.dsp.window.move({ direction = "d" }) },
    { "SHIFT + K",   hl.dsp.window.move({ direction = "u" }) },
    { "SHIFT + L",   hl.dsp.window.move({ direction = "r" }) },
    -- Special workspace
    { "S",           hl.dsp.workspace.toggle_special("magic") },
    { "SHIFT + S",   hl.dsp.window.move({ workspace = "special:magic" }) },
    -- Scroll through workspaces
    { "mouse_down",  hl.dsp.focus({ workspace = "e+1" }) },
    { "mouse_up",    hl.dsp.focus({ workspace = "e-1" }) },
}

for _, b in ipairs(mainMod_keybindings) do
    hl.bind(mainMod .. " + " .. b[1], b[2], b[3])
end

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse drag/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.define_submap("resize", function()
    local step = 80
    hl.bind("H", hl.dsp.window.resize({ x = -step, y = 0, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = -step, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y =  step, relative = true }), { repeating = true })
    hl.bind("L", hl.dsp.window.resize({ x =  step, y = 0, relative = true }), { repeating = true })
    hl.bind("ESCAPE", hl.dsp.submap("reset"))
end)

local single_key_bindings = {
    { "PRINT",                 exec("grim - | wl-copy") },
    
    { "XF86AudioRaiseVolume",  exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true } },
    { "XF86AudioLowerVolume",  exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { locked = true, repeating = true } },
    { "XF86AudioMute",         exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true } },
    { "XF86AudioMicMute",      exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true } },
    
    { "XF86AudioNext",         exec("playerctl next"),       { locked = true } },
    { "XF86AudioPause",        exec("playerctl play-pause"), { locked = true } },
    { "XF86AudioPlay",         exec("playerctl play-pause"), { locked = true } },
    { "XF86AudioPrev",         exec("playerctl previous"),   { locked = true } },
    
    { "XF86MonBrightnessUp",   exec("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true } },
    { "XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true } },
}

for _, b in ipairs(single_key_bindings) do
    hl.bind(b[1], b[2], b[3])
end
