#!/bin/bash

clients_json=$(hyprctl clients -j)

# Parse with jq and rename -98 workspace to "S"
output=$(echo "$clients_json" | jq -r '
  map({
    class: .class,
    title: .initialTitle,
    workspace: (if .workspace.id == -98 then "S" else (.workspace.id | tostring) end)
  }) |
  group_by(.workspace) | 
  map({
    ws: .[0].workspace,
    apps: map(.class) | join(", ")
  }) |
  sort_by(.ws | tonumber? // 999) |  # sort S last or keep it unordered if you prefer
  map("\(.ws): \(.apps)") |
  join("  ")
')

echo "{\"text\": \"$output\"}"

