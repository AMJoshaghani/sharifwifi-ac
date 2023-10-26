#!/bin/bash

CONF="$HOME/.config/sharif-wifi"

echo "=========================="
echo "removing..."
rm -r $CONF
systemctl stop sharif-wifi --user
systemctl disable sharif-wifi --user
rm "$HOME/.config/systemd/user/sharif-wifi.service"
echo "done."
echo "=========================="