sudo dnf install kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig -y
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda-libs -y

modinfo -F version nvidia

echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
echo "options nouveau modset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf

sudo dracut --force --verbose