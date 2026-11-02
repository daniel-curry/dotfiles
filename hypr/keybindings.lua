local local_config = require("local_config")

local browser = "uwsm app -- brave-origin -new-window"
local exec = hl.dsp.exec_cmd

local touchpad_enabled = true
local function toggle_touchpad()
    touchpad_enabled = not touchpad_enabled
    hl.device({ name = local_config.touchpad, enabled = touchpad_enabled })
    hl.notification.create({
        text = "Touchpad " .. (touchpad_enabled and "enabled" or "disabled"),
        timeout = 2000,
    })
end

-- Keep the cursor visible while steering it from the keyboard, and repeat keys
-- sooner and faster so held movement looks smooth
local saved_inactive_timeout, saved_repeat_rate, saved_repeat_delay
local function enter_cursor_mode()
    saved_inactive_timeout = hl.get_config("cursor.inactive_timeout")
    saved_repeat_rate = hl.get_config("input.repeat_rate")
    saved_repeat_delay = hl.get_config("input.repeat_delay")
    hl.config({
        cursor = { inactive_timeout = 0 },
        input = { repeat_rate = 60, repeat_delay = 200 },
    })
    hl.dispatch(hl.dsp.submap("cursor"))
end

local function exit_cursor_mode()
    hl.config({
        cursor = { inactive_timeout = saved_inactive_timeout },
        input = { repeat_rate = saved_repeat_rate, repeat_delay = saved_repeat_delay },
    })
    hl.dispatch(hl.dsp.submap("reset"))
end

local mainMod = local_config.mainMod
local mainMod_keybindings = {
    -- Programs
    { "RETURN",            exec("kitty") },
    { "B",                 exec(browser) },
    { "SPACE",             exec("~/.cargo/bin/scout") },
    { "ESCAPE",            exec("hyprlock") },
    { "PRINT",             exec('grim -g "$(slurp)" - | wl-copy') },
    -- Pressing again while the overlay is open closes it, so overlays can't stack.
    -- { "semicolon",         exec("pkill -x wl-kbptr || wl-kbptr -o modes=floating,click -o mode_floating.source=detect") },
    { "semicolon",         exec("pkill -x wl-kbptr || wl-kbptr-hypr-active-win -o modes=tile,tile,click -o mode_tile.keys=2,1 -o mode_click.button=left") },
    { "SHIFT + semicolon", exec("pkill -x wl-kbptr || wl-kbptr-hypr-active-win -o modes=tile,tile,click -o mode_tile.keys=2,1 -o mode_click.button=right") },
    { "apostrophe",        enter_cursor_mode },
    -- Web apps
    { "I",                 exec('claude-desktop') },
    { "T",                 exec(browser .. "=https://app.todoist.com") },
    { "O",                 exec(browser .. "=calendar.google.com") },
    -- System
    { "C",                 hl.dsp.window.close() },
    { "V",                 hl.dsp.window.float({ action = "toggle" }) },
    { "F",                 hl.dsp.window.fullscreen({ action = "toggle" }) },
    { "SHIFT + N",         exec("swaync-client -t") },
    { "SHIFT + T",         toggle_touchpad },
    { "R",                 hl.dsp.submap("resize") },
    -- Focus
    { "H",                 hl.dsp.focus({ direction = "left" }) },
    { "J",                 hl.dsp.focus({ direction = "down" }) },
    { "K",                 hl.dsp.focus({ direction = "up" }) },
    { "L",                 hl.dsp.focus({ direction = "right" }) },
    -- Move
    { "SHIFT + H",         hl.dsp.window.move({ direction = "l" }) },
    { "SHIFT + J",         hl.dsp.window.move({ direction = "d" }) },
    { "SHIFT + K",         hl.dsp.window.move({ direction = "u" }) },
    { "SHIFT + L",         hl.dsp.window.move({ direction = "r" }) },
    -- Special workspace
    { "S",                 hl.dsp.workspace.toggle_special("magic") },
    { "SHIFT + S",         hl.dsp.window.move({ workspace = "special:magic" }) },
    -- Scroll through workspaces
    -- { "mouse_down",        hl.dsp.focus({ workspace = "e+1" }) },
    -- { "mouse_up",          hl.dsp.focus({ workspace = "e-1" }) },
}

for _, b in ipairs(mainMod_keybindings) do
    hl.bind(mainMod .. " + " .. b[1], b[2], b[3])
end

-- Hyprland cancels key repeat on any scroll event, so `repeating` can't work here
local function held_scroll(key, amount)
    local cmd = "ydotool mousemove -w -- 0 " .. amount
    local timer = hl.timer(function() hl.exec_cmd(cmd) end, { timeout = 100, type = "repeat" })
    timer:set_enabled(false)

    hl.bind(mainMod .. " + " .. key, function()
        hl.exec_cmd(cmd)
        timer:set_timeout(250)
    end)
    hl.bind(key, function() timer:set_enabled(false) end, {
        release = true,
        ignore_mods = true,
        non_consuming = true,
        transparent = true,
        locked = true,
    })
end

held_scroll("D", -1)
held_scroll("U", 1)

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse drag/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.define_submap("resize", function()
    local step = 80
    hl.bind("H", hl.dsp.window.resize({ x = -step, y = 0, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = -step, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = step, relative = true }), { repeating = true })
    hl.bind("L", hl.dsp.window.resize({ x = step, y = 0, relative = true }), { repeating = true })
    hl.bind("ESCAPE", hl.dsp.submap("reset"))
end)

hl.define_submap("cursor", function()
    local step = 8
    -- hl.dsp.cursor.move sends no wl_pointer.frame, so apps never register the hover
    local function move(dx, dy)
        local cmd = ("ydotool mousemove -- %d %d"):format(dx, dy)
        return function() hl.exec_cmd(cmd) end
    end
    hl.bind("H", move(-step, 0), { repeating = true })
    hl.bind("J", move(0, step), { repeating = true })
    hl.bind("K", move(0, -step), { repeating = true })
    hl.bind("L", move(step, 0), { repeating = true })
    hl.bind("F", function()
        exit_cursor_mode()
        hl.exec_cmd("ydotool click 0xC0") -- left button down + up
    end)
    hl.bind("ESCAPE", exit_cursor_mode)
end)

local single_key_bindings = {
    { "PRINT",                 exec("grim - | wl-copy") },

    { "XF86AudioRaiseVolume",  exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),                   { locked = true, repeating = true } },
    { "XF86AudioLowerVolume",  exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),                        { locked = true, repeating = true } },
    { "XF86AudioMute",         exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),                       { locked = true } },
    { "XF86AudioMicMute",      exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                     { locked = true } },

    { "XF86AudioNext",         exec("playerctl next"),                                                   { locked = true } },
    { "XF86AudioPause",        exec("playerctl play-pause"),                                             { locked = true } },
    { "XF86AudioPlay",         exec("playerctl play-pause"),                                             { locked = true } },
    { "XF86AudioPrev",         exec("playerctl previous"),                                               { locked = true } },

    -- { "XF86MonBrightnessUp",   exec("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true } },
    -- { "XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true } },
    { "XF86MonBrightnessUp",   exec("ddcutil --bus 10 --noverify --sleep-multiplier 0.1 setvcp 10 + 5"), { locked = true, repeating = false } },
    { "XF86MonBrightnessDown", exec("ddcutil --bus 10 --noverify --sleep-multiplier 0.1 setvcp 10 - 5"), { locked = true, repeating = false } },
}

for _, b in ipairs(single_key_bindings) do
    hl.bind(b[1], b[2], b[3])
end
