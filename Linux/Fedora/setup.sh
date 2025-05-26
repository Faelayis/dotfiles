#!/bin/bash

sudo dnf remove google-droid-sans-fonts

# Install Fonts
sudo dnf install -y google-noto-sans-fonts google-noto-sans-thai-fonts \
   cascadia-code-fonts cascadia-code-pl-fonts cascadia-mono-fonts cascadia-mono-pl-fonts

# Install additional Noto fonts
package_list=$(sudo dnf list | grep -P 'google-noto-(?!.*-vf-fonts\.noarch).*\.noarch' | awk '{printf $1" "}')
sudo dnf install -y $package_list --skip-broken --best --allowerasing && sudo fc-cache -v

# Gnome Settings
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>Shift_L', '<Shift>Alt_L']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"
gsettings set org.gnome.desktop.session idle-delay 180

# Power settings for GDM
for setting in sleep-inactive-ac-timeout sleep-inactive-battery-timeout sleep-inactive-battery-type sleep-inactive-ac-type; do
   value=0
   [ "$setting" == "sleep-inactive-battery-type" ] || [ "$setting" == "sleep-inactive-ac-type" ] && value=nothing
   sudo -u gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power $setting $value
done
