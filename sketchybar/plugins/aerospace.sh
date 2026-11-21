#!/usr/bin/env bash

. "$CONFIG_DIR/colors.sh"

get_workspace_label() {
  case $1 in
    1) echo "I" ;;
    2) echo "II" ;;
    3) echo "III" ;;
    4) echo "IV" ;;
    5) echo "V" ;;
    6) echo "VI" ;;
    7) echo "VII" ;;
    8) echo "VIII" ;;
    9) echo "IX" ;;
    10) echo "X" ;;
    *) echo "$1" ;;
  esac
}

sid=$1
label_sid=$(get_workspace_label "$sid")

if [ -z "$sid" ]; then
  sid=$FOCUSED_WORKSPACE
fi

# On startup/forced updates there is no event payload, so ask aerospace
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused)"
fi

# Each workspace gets its own color (Jac-Zac's COLORS_SPACE order)
case "$sid" in
  1)  ACCENT="$WHITE" ;;
  2)  ACCENT="$LIGHT_BLUE" ;;
  3)  ACCENT="$CYAN" ;;
  4)  ACCENT="$BLUE" ;;
  5)  ACCENT="$DARK_BLUE" ;;
  6)  ACCENT="$MAGENTA" ;;
  7)  ACCENT="$RED" ;;
  8)  ACCENT="$ORANGE" ;;
  9)  ACCENT="$YELLOW" ;;
  10) ACCENT="$GREEN" ;;
  *)  ACCENT="$WHITE" ;;
esac

apps=$(aerospace list-windows --workspace "$sid" | \
  awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

icon_strip=" "
if [ -n "$apps" ]; then
  while read -r app; do
    icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
  done <<< "$apps"
else
  icon_strip=""
fi

# Determine if this workspace should be visible
# (has windows or is the focused workspace)
if [ -n "$apps" ] || [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set space.$sid label="$icon_strip" icon="$label_sid" drawing=on
else
  sketchybar --set space.$sid drawing=off
fi

# Focused workspace: filled with its color, dark text.
# Others: no fill, numeral and app icons in the workspace color.
if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.drawing=on background.color="$ACCENT" \
    icon.color="$BACKGROUND_2" label.color="$BACKGROUND_2"
else
  sketchybar --set $NAME background.drawing=off \
    icon.color="$ACCENT" label.color="$ACCENT"
fi
