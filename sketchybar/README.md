# Sketchybar Setup

First, you'll need to edit some of the plugins to make sure it works with the VPN you're using. 

You can re-write a bunch of the logic, but essentially I'm just grepping the output of ifconfig to determine if ipsec0 exists in ifconfig, which is how NordVPN's manual installation logic creates. I've also sourced the IP address of NordVPN's IP address that it creates in ifconfig, and determines if that exists. If you're using NordVPN as well, you'll need to create a file in the $CONFIG_DIR (the base sketchybar directory) and call it VPN_IP.
