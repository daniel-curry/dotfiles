hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("GTK_MODULES", "gail:atk-bridge")
hl.env("QT_ACCESSIBILITY", 1)
local local_config = require("local_config")
require("autostart")
require("appearance")
require("keybindings")
if local_config.is_laptop then
    require("clamshell")
end
