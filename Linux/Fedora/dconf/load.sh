#!/bin/bash

cat media-keys | dconf load /org/gnome/settings-daemon/plugins/media-keys/
cat keybindings | dconf load /org/gnome/desktop/wm/keybindings/