#!/usr/bin/env bash

get_chinese_number() {
  case $1 in
    1) echo "一" ;;
    2) echo "二" ;;
    3) echo "三" ;;
    4) echo "四" ;;
    5) echo "五" ;;
    6) echo "六" ;;
    7) echo "七" ;;
    8) echo "八" ;;
    9) echo "九" ;;
    10) echo "十" ;;
    *) echo "$1" ;;
  esac
}

sid=$1
chinese_sid=$(get_chinese_number "$sid")

if [ -z "$sid" ]; then
  sid=$FOCUSED_WORKSPACE
fi

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
  # sketchybar --set space.$sid label="$icon_strip" drawing=on
  sketchybar --set space.$sid label="$icon_strip" icon="$chinese_sid" drawing=on
else
  sketchybar --set space.$sid drawing=off
fi

# Standard workspace check and style
if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.color=0x0C10F5 label.shadow.drawing=on icon.shadow.drawing=on background.border_width=2
else
  sketchybar --set $NAME background.color=0x44FFFFFF label.shadow.drawing=off icon.shadow.drawing=off background.border_width=0
fi