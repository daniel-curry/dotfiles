#!/bin/bash

clients_json=$(hyprctl clients -j)
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Parse with jq and tag the current workspace
output=$(echo "$clients_json" | jq -r --argjson current "$current_ws" '
  map({
    class: .class,
    title: .initialTitle,
    workspace: (
      if .workspace.id == -98 then "S"
      elif .workspace.id == $current then "__ACTIVE__" + (.workspace.id | tostring)
      else (.workspace.id | tostring)
      end
    )
  }) |
  group_by(.workspace) |
  map({
    ws: .[0].workspace,
    apps: map(.class) | join(", ")
  }) |
  sort_by(.ws | sub("__ACTIVE__";"") | tonumber? // 999) |
  map(
    if .ws | test("^__ACTIVE__") then
      "**" + (.ws | sub("__ACTIVE__";"")) + ": \(.apps)" + "**"
    else
      "\(.ws): \(.apps)"
    end
  ) |
  join("  ")
')

echo "{\"text\": \"$output\"}"

