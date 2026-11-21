#!/bin/sh

# Upload / download speed of the active network connection.
# Runs on net.down and updates both stacked items (net.up sits on top).

# Interface carrying the default route (Wi-Fi, Ethernet, or a VPN tunnel)
IF="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')"
IF="${IF:-en0}"

# Cumulative byte counters, read from the end of the <Link#> row
# (the Address column can be empty, so counting from the left is unreliable)
set -- $(netstat -ibn -I "$IF" 2>/dev/null | awk '/Link#/{print $(NF-4), $(NF-1); exit}')
RX="${1:-0}"
TX="${2:-0}"
NOW="$(date +%s)"

STATE="${TMPDIR:-/tmp}/sketchybar_net_state"
if [ -f "$STATE" ]; then
  read -r P_IF P_RX P_TX P_T < "$STATE"
fi
echo "$IF $RX $TX $NOW" > "$STATE"

# First run, interface switch, or counter reset: show zero this round
if [ "$P_IF" != "$IF" ] || [ -z "$P_T" ] || [ "$NOW" -le "$P_T" ] \
   || [ "$RX" -lt "$P_RX" ] || [ "$TX" -lt "$P_TX" ]; then
  DOWN=0; UP=0
else
  DT=$((NOW - P_T))
  DOWN=$(((RX - P_RX) / DT))
  UP=$(((TX - P_TX) / DT))
fi

# Fixed-width formatting so the two rows line up: 011KBps / 1.2MBps
fmt() {
  awk -v b="$1" 'BEGIN {
    kb = b / 1024
    if (kb < 1000) printf "%03dKBps", kb
    else           printf "%.1fMBps", kb / 1024
  }'
}

sketchybar --set net.up   label="$(fmt "$UP")" \
           --set net.down label="$(fmt "$DOWN")"
