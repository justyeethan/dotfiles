#!/bin/env/bash

clock=(
	"${menu_defaults[@]}"
	icon.drawing=off
	label.font="$FONT:Bold:18"
	label.padding_right=4
	y_offset=0
	update_freq=10
	popup.align=right
	script="$PLUGIN_DIR/nextevent.sh"
	click_script="sketchybar --set clock popup.drawing=toggle; open -a Calendar.app"
)

calendar_popup=(
	icon.drawing=off
	label.padding_left=0
	label.max_chars=22
)

sketchybar \
	--add item clock right \
	--set clock "${clock[@]}" \
	--subscribe clock system_woke \
	mouse.entered \
	mouse.exited \
	mouse.exited.global \
	--add item clock.next_event popup.clock \
	--set clock.next_event "${menu_item_defaults[@]}" "${calendar_popup[@]}"
