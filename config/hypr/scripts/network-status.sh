#!/bin/bash
if ping -c 1 -W 1 8.8.8.8 &>/dev/null; then
    if command -v nmcli &>/dev/null; then
        SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
        if [ -n "$SSID" ] && [ ${#SSID} -le 15 ]; then
            echo "󰖨 $SSID"
        else
            echo "󰈀 Connected"
        fi
    else
        echo "󰈀 Online"
    fi
else
    echo "󰖪 Offline"
fi
