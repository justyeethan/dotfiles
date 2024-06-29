#!/usr/bin/env bash

render_item() {
	sketchybar --set $NAME label="$(date "+􀉉 %a %b %d  􀐬 %I:%M %p")" \
		--set date icon.drawing=$drawing
}

update() {
	render_item
}

case "$SENDER" in
"routine" | "forced")
	update
	;;
"mouse.entered")
	popup on
	;;
"mouse.exited" | "mouse.exited.global")
	popup off
	;;
esac

