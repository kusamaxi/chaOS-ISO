#!/usr/bin/env bash
set -e

# Set variables
mirrorlist_url="https://raw.githubusercontent.com/kusamaxi/chaOS-ISO/main/mirrorlist"
wallpaper_url="https://raw.githubusercontent.com/kusamaxi/chaos-theming/master/backgrounds/chaos-wallpaper.png"
chaos_repo_url="https://github.com/kusamaxi/chaOS"

mirrorlist_dest="airootfs/etc/pacman.d/"
wallpaper_dest="airootfs/root/"
packages_dest="airootfs/root/packages"
chaos_skel_dest="airootfs/root/chaos-skel-liveuser"
config_dest="airootfs/etc/skel/.config/"

# Download mirrorlist for offline installs
wget -qN --show-progress -P "${mirrorlist_dest}" "${mirrorlist_url}"

# Download wallpaper for installed system
wget -qN --show-progress -P "${wallpaper_dest}" "${wallpaper_url}"

# Make sure build scripts are executable
chmod +x "./"{mkarchiso,run_before_squashfs.sh}

# Function to download and set ownership of packages
get_pkg() {
	sudo pacman -Syw "$1" --noconfirm --cachedir "${packages_dest}" &&
		sudo chown $USER:$USER "${packages_dest}/"*".pkg.tar"*
}

get_pkg "chaos-skel-xfce4"

# Build liveuser skel
pushd "${chaos_skel_dest}"
makepkg -f
popd

# Clone chaOS repository and install config folder content into live system liveuser .config folder
git clone "${chaos_repo_url}" "/tmp/chaOS"
cp -r "/tmp/chaOS/config" "${config_dest}"
rm -rf "/tmp/chaOS"
