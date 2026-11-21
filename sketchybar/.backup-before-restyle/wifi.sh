#!/bin/sh

# Wi-Fi connected / disconnected, plus a lock when a VPN is up.

LOCK_COLOR="0xffffffff"

# Find the Wi-Fi interface (usually en0, but not always)
WIFI_IF="$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2; exit}')"
WIFI_IF="${WIFI_IF:-en0}"

# Connected = the Wi-Fi interface has an IPv4 address.
# (SSID lookups are redacted on recent macOS, so we don't rely on them.)
if ipconfig getifaddr "$WIFI_IF" >/dev/null 2>&1; then
  ICON="􀙇"         # SF Symbol: wifi
  ICON_COLOR="0xffffffff"
else
  ICON="􀙈"         # SF Symbol: wifi.slash
  ICON_COLOR="0x80ffffff"
fi

# VPN detection:
#  1. VPNs configured in System Settings (IKEv2, L2TP, most App Store VPN apps)
#  2. Any tunnel interface holding an IPv4 address (WireGuard, OpenVPN,
#     Tailscale, corporate clients...). macOS keeps a few utun interfaces
#     around for its own use, but those only carry IPv6 link-local addresses.
VPN="off"
if scutil --nc list 2>/dev/null | grep -q '(Connected)'; then
  VPN="on"
else
  for i in $(ifconfig -l); do
    case "$i" in
      utun*|ipsec*|ppp*|tun*|wg*)
        if ifconfig "$i" 2>/dev/null | grep -q 'inet '; then
          VPN="on"
          break
        fi
        ;;
    esac
  done
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$ICON_COLOR" \
  label="􀎡" \
  label.color="$LOCK_COLOR" \
  label.drawing="$VPN"
