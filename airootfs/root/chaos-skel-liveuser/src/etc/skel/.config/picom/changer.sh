#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 none|clear|blur"
    exit 1
fi

CONFIG_NAME="$1"
PICOM_CONF_DIR="$HOME/xi/chaOS-config/config/picom"
PICOM_LINK_DIR="$HOME/.config/picom"

if [ ! -d "$PICOM_CONF_DIR" ]; then
    echo "Configuration directory not found: $PICOM_CONF_DIR"
    exit 1
fi

# if no  link dir exist lets do it
if [ ! -d "$PICOM_LINK_DIR" ]; then
    # Link the picom config folder to the ~/.config path
    ln -s "$PICOM_CONF_DIR" "$PICOM_LINK_DIR"
fi

case $CONFIG_NAME in
    none|clear|blur)
        ;;
    *)
        echo "Invalid argument. Usage: $0 none|clear|blur"
        exit 1
        ;;
esac

CONFIG_FILE="$PICOM_CONF_DIR/$CONFIG_NAME.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

pkill picom

# Wait for picom to completely shut down
while pgrep -x picom >/dev/null; do
    sleep 0.1
done

picom --config "$CONFIG_FILE" -b &
