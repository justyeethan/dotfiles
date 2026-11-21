#!/usr/bin/env bash

# Front app pill: app icon + name. Click it to list the app's menu bar
# menus as a column of pills; click one of those to open that real menu.
# Reading/clicking menus goes through System Events, so macOS asks once to
# let SketchyBar control your computer (Settings > Privacy > Accessibility).

MAX=20
OPEN_FLAG="${TMPDIR:-/tmp}/sketchybar_menus_open"

# Frontmost app name: lsappinfo is built into macOS and needs no permissions
frontmost_app() {
  name="$(lsappinfo info -only name "$(lsappinfo front)" 2>/dev/null \
    | sed -n 's/.*"LSDisplayName"="\(.*\)"/\1/p')"
  [ -z "$name" ] && name="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)"
  echo "$name"
}

set_app() {
  APP="$1"
  [ -z "$APP" ] && APP="$(frontmost_app)"
  [ -z "$APP" ] && return
  sketchybar --set front_app \
    icon="$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$APP")" \
    label="$APP"
}

hide_menus() {
  rm -f "$OPEN_FLAG"
  sketchybar --set front_app popup.drawing=off
}

show_menus() {
  # Menu titles of the frontmost app, one per line
  # (separate -e lines: macOS's bash 3.2 can't parse a heredoc inside $(...))
  MENUS="$(osascript \
    -e 'tell application "System Events"' \
    -e 'set p to first application process whose frontmost is true' \
    -e 'set n to name of every menu bar item of menu bar 1 of p' \
    -e 'end tell' \
    -e "set AppleScript's text item delimiters to linefeed" \
    -e 'return n as text' 2>/dev/null)"
  [ -z "$MENUS" ] && return

  args=()
  i=0
  while IFS= read -r name && [ "$i" -lt "$MAX" ]; do
    [ -z "$name" ] && continue
    n=$((i + 1))
    args+=(--set "menu.$i" drawing=on label="$name ▸"
      click_script="sketchybar --set front_app popup.drawing=off; rm -f '$OPEN_FLAG'; osascript -e 'tell application \"System Events\" to tell (first application process whose frontmost is true) to click menu bar item $n of menu bar 1' >/dev/null 2>&1 &")
    i=$((i + 1))
  done <<< "$MENUS"
  while [ "$i" -lt "$MAX" ]; do
    args+=(--set "menu.$i" drawing=off)
    i=$((i + 1))
  done

  touch "$OPEN_FLAG"
  sketchybar "${args[@]}" --set front_app popup.drawing=on
}

case "$SENDER" in
  front_app_switched)
    hide_menus
    set_app "$INFO"
    ;;
  mouse.clicked)
    if [ -f "$OPEN_FLAG" ]; then hide_menus; else show_menus; fi
    ;;
  mouse.exited.global)
    hide_menus
    ;;
  *)
    # Startup, forced update, workspace change, wake
    set_app ""
    ;;
esac
