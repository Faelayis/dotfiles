# Font
sudo dnf install google-noto-sans-fonts google-noto-sans-thai-fonts
sudo dnf install cascadia-code-fonts cascadia-code-pl-fonts cascadia-mono-fonts cascadia-mono-pl-fonts
package_list=$(sudo dnf list | grep -P 'google-noto-(?!.*-vf-fonts\.noarch).*\.noarch' | awk '{printf $1" "}')
sudo dnf install -y $package_list --skip-broken --best --allowerasing && sudo fc-cache -v

# Gnome Settings
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>Shift_L', '<Shift>Alt_L']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"
