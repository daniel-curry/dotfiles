----- Clamshell -----
local vars = require("local_config")

local INTERNAL  = vars.internal.output
local LID_STATE = "/proc/acpi/button/lid/LID0/state"   -- check `ls /proc/acpi/button/lid/`

-- Logical size of a monitor: pixels / scale (1920 / 1.2 = 1600). Scale is snapped
-- to the nearest 1/120 first, as Hyprland does (1.33 becomes 4/3, so 3440 -> 2580).
local function logical_size(mon)
    local px_w, px_h = mon.mode:match("^(%d+)x(%d+)")
    local scale = math.floor(mon.scale * 120 + 0.5) / 120
    return math.floor(tonumber(px_w) / scale + 0.5), math.floor(tonumber(px_h) / scale + 0.5)
end

local internal_w             = logical_size(vars.internal)
local external_w, external_h = logical_size(vars.external)

-- External is pinned at the origin, so disabling the laptop panel never moves it.
hl.monitor({
    output   = vars.external.output,
    mode     = vars.external.mode,
    position = "0x0",
    scale    = vars.external.scale,
})

-- Internal sits directly below the external, horizontally centered on it.
local function internal_rule(disabled)
    return {
        output   = INTERNAL,
        mode     = vars.internal.mode,
        position = math.floor((external_w - internal_w) / 2) .. "x" .. external_h,
        scale    = vars.internal.scale,
        disabled = disabled,
    }
end

local function lid_closed_from_proc()
    local f = io.open(LID_STATE, "r")
    if not f then return false end          -- can't tell → assume open (fail toward screen ON)
    local s = f:read("*a")
    f:close()
    return s:find("closed") ~= nil
end

local function external_active()
    for _, m in ipairs(hl.get_monitors()) do
        if m.name ~= INTERNAL and m.name ~= "FALLBACK" then
            return true
        end
    end
    return false
end

local function want_internal_off(lid_hint)
    local closed = lid_hint
    if closed == nil then closed = lid_closed_from_proc() end
    return closed and external_active()
end

local function apply(lid_hint)
    local want_off = want_internal_off(lid_hint)
    local is_off   = hl.get_monitor(INTERNAL) == nil
    if want_off == is_off then return end   -- already correct; skip a needless modeset
    hl.monitor(internal_rule(want_off))
end

-- Declarative on load/reload
hl.monitor(internal_rule(want_internal_off()))

hl.on("monitor.added",   function() apply() end)
hl.on("monitor.removed", function() apply() end)
hl.bind("switch:on:Lid Switch",  function() apply(true)  end, { locked = true })
hl.bind("switch:off:Lid Switch", function() apply(false) end, { locked = true })

-- Escape hatch: force the panel on regardless of logic.
hl.bind(vars.mainMod .. " + SHIFT + M", function()
    hl.monitor(internal_rule(false))
end, { locked = true })