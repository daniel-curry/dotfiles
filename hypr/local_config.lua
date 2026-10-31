-- Typical Laptop Settings
-- ==============================
-- local local_config_options = {
--     input = {
--         touchpad = {
--             natural_scroll = true,
--             scroll_factor = 0.10,
--             disable_while_typing = true,
--             tap_to_click = true,
--             clickfinger_behavior = true
--         },
--         accel_profile = "flat",
--         sensitivity = 0.25
--     }
-- }

-- local gesture_rules = {
--     { fingers = 3, direction = "horizontal", action = "workspace", scale = 0.65 },
--     { fingers = 3, direction = "vertical",   action = "special",   workspace_name = "magic" }
-- }
-- ==============================

for _, gesture in ipairs(gesture_rules) do
    hl.gesture(gesture)
end

if local_config_options then
    hl.config(local_config_options)
end

local M = {}

--[[
Available local configuration options:
M.mainMod
M.touchpad
M.internal (internal laptop display)
M.external (external monitor)
M.is_laptop (bool; determines whether to include laptop-specific options)

monitors follow:
hl.monitor({
    output = "monitor name via hyprctl",
    mode = "WxH@hz",
    position = "nxn",
    scale = decimal,
})

]]

return M
