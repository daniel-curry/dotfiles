hl.env("ELECTON_OZONE_PLATFORM_HINT","wayland")
hl.env("GTK_MODULES", "gail:akt-bridge")
hl.env("QT_ACCESSIBILITY", 1)

require("local_config")
require("autostart")
require("appearance")
require("keybindings")
