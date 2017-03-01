#!/bin/bash

set -eu

echo "This hasn't been tested. Read it first." && exit 1

for group in dialout plugdev; do
    cmd="sudo usermod -aG $group "$USER""
    echo $cmd
    $cmd
done

XORG_CONF_D=/usr/share/X11/xorg.conf.d
if [ ! -d "$XORG_CONF_D" ]; then
    echo "No directory $XORG_CONF_D"
    exit 1
fi

xorg_conf_file="$XORG_CONF_D/50-enable-backspace-zap.conf"
if [ -f "$xorg_conf_file" ]; then
    echo "$xorg_conf_file exists already"
else
    echo "Writing $xorg_conf_file so you can zap X11 with ctrl+alt+backspace"
    sudo cp ~/dotfiles/xorg.conf "$xorg_conf_file"
fi
