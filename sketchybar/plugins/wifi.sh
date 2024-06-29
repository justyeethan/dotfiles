#!/bin/bash

# Loads defined colors
source "$CONFIG_DIR/colors.sh"

POPUP_OFF="sketchybar --set wifi popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set wifi popup.drawing=toggle"

# Workaround for IKEv2 vpn connections not showing up. Checks if ipsec0 is active
IS_VPN=$(ifconfig ipsec0)

#IS_VPN="Disconnected" # TODO Fix VPN access and CURRENT_WIFI to use utils
CURRENT_WIFI="$(ifconfig en0 | awk '/status:/{print $2}')"
IP_ADDRESS="$(ipconfig getifaddr en0)"
IS_HOTSPOT="$(networksetup -getairportnetwork en0)"
CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"

if ifconfig | grep -q "^ipsec0"; then
	IS_VPN=true
else
	IS_VPN=false
fi
echo $IS_VPN

if [[ "$IS_VPN" = true ]]; then
	ICON_COLOR=$HIGHLIGHT
	ICON=􀎡
elif [[ $IS_HOTSPOT = "Current Wi-Fi Network: Ethan’s iPhone" ]]; then
	ICON_COLOR=$(getcolor white)
	ICON=􀉤
elif [[ $CURRENT_WIFI != "inactive" ]]; then
	ICON_COLOR=$(getcolor white)
	ICON=􀐿
elif [[ $CURRENT_WIFI = "AirPort: Off" ]]; then
	ICON=􀐾
else
	ICON_COLOR=$(getcolor white 25)
	ICON=􀐾
fi

render_bar_item() {
	sketchybar --set $NAME \
		icon.color=$ICON_COLOR \
		icon.font.size=18.0 \
		icon=$ICON \
		click_script="$POPUP_CLICK_SCRIPT"
}

render_popup() {
	if [ "$SSID" != "" ]; then
		args=(
			--set wifi click_script="$POPUP_CLICK_SCRIPT"
			--set wifi.ssid label="$SSID"
			--set wifi.strength label="$CURR_TX Mbps"
			--set wifi.ipaddress label="$IP_ADDRESS"
			click_script="printf $IP_ADDRESS | pbcopy;$POPUP_OFF"
		)
	else
		args=(
			--set wifi click_script="")
	fi

	sketchybar "${args[@]}" >/dev/null
}

update() {
	render_bar_item
	render_popup
}

popup() {
	sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
"routine" | "forced")
	update
	;;
"mouse.clicked")
	popup on
	;;
"mouse.exited" | "mouse.exited.global")
	popup off
	;;
esac

# click_script="sketchybar --set wifi.alias popup.drawing=toggle; $WIFI_CLICK_SCRIPT" \
