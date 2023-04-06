#!/usr/bin/env bash

# Get mirrorlist for offline installs
wget -qN --show-progress -P "airootfs/etc/pacman.d/" "https://raw.githubusercontent.com/kusamaxi/chaOS-ISO/main/mirrorlist"

# Get wallpaper for installed system
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/kusamaxi/chaos-theming/master/backgrounds/chaos-wallpaper.png"

# current downgrade mesa for calamares lag in vms:
#wget "https://archive.archlinux.org/packages/m/mesa/mesa-22.1.7-1-x86_64.pkg.tar.zst"
#mv mesa-22.1.7-1-x86_64.pkg.tar.zst "airootfs/root/packages/"

# Make sure build scripts are executable
chmod +x "./"{"mkarchiso","run_before_squashfs.sh"}

get_pkg() {
    sudo pacman -Syw "$1" --noconfirm --cachedir "airootfs/root/packages" \
    && sudo chown $USER:$USER "airootfs/root/packages/"*".pkg.tar"*
}

get_pkg "chaos-skel-xfce4"

# Build liveuser skel
cd "airootfs/root/chaos-skel-liveuser"
makepkg -f
