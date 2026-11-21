#!/bin/sh

# CPU utilization as a pie chart icon (Nerd Font circle-slice glyphs).
# Total %CPU across all processes, normalized by logical core count.

CORES="$(sysctl -n hw.logicalcpu)"
CPU="$(ps -A -o %cpu= | awk -v c="$CORES" '{s+=$1} END {p=s/c; if (p>100) p=100; printf "%d", p+0.5}')"

# Map 0-100% onto 0-8 slices
SLICE=$(( (CPU * 8 + 50) / 100 ))

case "$SLICE" in
  0) ICON="󰝦" ;;  # empty circle
  1) ICON="󰪞" ;;
  2) ICON="󰪟" ;;
  3) ICON="󰪠" ;;
  4) ICON="󰪡" ;;
  5) ICON="󰪢" ;;
  6) ICON="󰪣" ;;
  7) ICON="󰪤" ;;
  *) ICON="󰪥" ;;  # full circle
esac

# White normally, orange when busy, red when pegged
if [ "$CPU" -ge 90 ]; then
  COLOR="0xffed8796"
elif [ "$CPU" -ge 70 ]; then
  COLOR="0xfff5a97f"
else
  COLOR="0xffffffff"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${CPU}%"
