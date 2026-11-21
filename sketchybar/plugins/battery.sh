#!/bin/sh

. "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="􀛨"; COLOR="$GREEN" ;;
  [5-8][0-9]) ICON="􀺸"; COLOR="$GREEN" ;;
  [3-4][0-9]) ICON="􀺶"; COLOR="$YELLOW" ;;
  [1-2][0-9]) ICON="􀛩"; COLOR="$ORANGE" ;;
  *)          ICON="􀛪"; COLOR="$RED" ;;
esac

# Plugged in: battery-with-bolt (keeps the charge-level color)
if [ -n "$CHARGING" ]; then
  ICON="􀢋"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
