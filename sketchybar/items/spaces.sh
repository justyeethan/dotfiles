#!/bin/bash

# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

# Defaults
spaces=(
	background.height=20
	background.corner_radius=50
	icon.padding_left=2
	icon.padding_right=2
	label.padding_right=4
)

SPACE_ICONS=("一" "二" "三" "四" "五" "六" "七" "八" "九" "十")
SPACES=()

for i in "${!SPACE_ICONS[@]}"; do
	sid=$(($i + 1))
	SPACES+=(space.$sid)
	sketchybar --add space space.$sid left \
		--set space.$sid associated_space=$sid \
		icon=${SPACE_ICONS[i]} \
		icon.font="SF Pro:bold:17.0" \
		icon.padding_left=12 \
		icon.padding_right=12 \
		icon.highlight_color=0xffFF6C8D \
		click_script="yabai -m space --focus $sid"
done
