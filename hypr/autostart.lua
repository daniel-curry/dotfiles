hl.on("hyprland.start", function()

    local startup_apps = {
        "nm-applet",
        "hyprpaper",
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE",
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE",
        "pkill mako; swaync",
        "swayidle -w timeout 1200 hyprlock",
        "~/dotfiles/waybar/hypr_listener.sh &",
        "spotify", {workspace = "special:magic silent"}
    }

    for _, a in ipairs(startup_apps) do
        hl.exec_cmd(a)
    end

end)
