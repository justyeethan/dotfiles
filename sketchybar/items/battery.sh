#!/bin/env/bash

battery=(
	icon.font.size=20
	icon.font.position=center
	icon.padding_right=0
	icon.font.style="Light"
	update_freq=10
	popup.align=right
	script="$PLUGIN_DIR/battery.sh"
)

sketchybar \
	--add item battery right \
	--set battery "${battery[@]} " \
	--subscribe battery power_source_change \
	mouse.clicked
