#!/usr/bin/env bash
# hypr-signal-waybar-v2.sh
#
# Send SIGUSR2 to Waybar whenever Hyprland’s state actually changes,
# with startup-kick, debounce, and feedback-loop protection.

set -euo pipefail

# ────────────── tweakables ────────────────────────────────────────────────────
DEBOUNCE_MS=250                       # don’t spam Waybar faster than this
IGNORE_CLASSES_REGEX='^(waybar)$'     # window classes that should NOT retrigger
# ──────────────────────────────────────────────────────────────────────────────

# locate Hyprland’s push-event socket (socket2)
SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/.socket2.sock"
[[ -S $SOCKET ]] || {
  echo "Could not find Hyprland socket2 at $SOCKET" >&2
  exit 1
}

now_ms() { date +%s%3N; }
notify_waybar() { pkill -USR2 -x waybar 2>/dev/null || true; }

# one-shot kick so Waybar sees pre-existing windows/workspaces
if pgrep -x waybar >/dev/null; then
  notify_waybar            # immediate
  sleep 0.5 && notify_waybar &  #…and again half a second later
fi

last_sent=0
handle_event() {
  local line="$1" ev payload cls
  ev=${line%%>>*}
  payload=${line#*>>}

  # react to the core client/workspace events (incl. added/removed)
  case "$ev" in
    openwindow|closewindow|client-added|client-removed|workspace|urgent*) ;;
    *) return ;;
  esac

  # skip Waybar-generated windows so we don’t loop forever
  if [[ $ev == openwindow || $ev == closewindow ]]; then
    IFS=',' read -r _addr cls _ <<< "$payload"
    [[ $cls =~ $IGNORE_CLASSES_REGEX ]] && return
  fi

  # debounce
  local now; now=$(now_ms)
  (( now - last_sent < DEBOUNCE_MS )) && return
  last_sent=$now

  notify_waybar
}

# main loop – auto-reconnect on Hyprland restart
while true; do
  socat -u UNIX-CONNECT:"$SOCKET" - | while IFS= read -r line; do
    handle_event "$line"
  done
  sleep 1   # socket disappeared (likely compositor restart) -> retry
done

