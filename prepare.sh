#!/usr/bin/env bash
set -euo pipefail

# Log function
log() {
	echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Set variables
mirrorlist_url="https://raw.githubusercontent.com/kusamaxi/chaOS-ISO/main/mirrorlist"
wallpaper_url="https://raw.githubusercontent.com/kusamaxi/chaos-theming/master/backgrounds/chaos-wallpaper.png"
chaos_repo_url="https://github.com/kusamaxi/chaOS"

mirrorlist_dest="airootfs/etc/pacman.d/"
wallpaper_dest="airootfs/root/"
packages_dest="airootfs/root/packages"
chaos_skel_dest="airootfs/root/chaos-skel-liveuser"
config_dest="airootfs/etc/skel/.config/"

log "Downloading mirrorlist for offline installs"
wget -qN --show-progress -P "${mirrorlist_dest}" "${mirrorlist_url}"

log "Downloading wallpaper for installed system"
wget -qN --show-progress -P "${wallpaper_dest}" "${wallpaper_url}"

log "Making sure build scripts are executable"
chmod +x "./"{mkarchiso,run_before_squashfs.sh}

log "Function to download and set ownership of packages"
get_pkg() {
	sudo pacman -Syw "$1" --noconfirm --cachedir "${packages_dest}" &&
		sudo chown $USER:$USER "${packages_dest}/"*".pkg.tar"*
}

log "Getting chaos-skel-xfce4 package"
get_pkg "chaos-skel-xfce4"

log "Building liveuser skel"
pushd "${chaos_skel_dest}"
makepkg -f
popd

log "Cloning chaOS repository and installing config folder content into live system liveuser .config folder"
git clone "${chaos_repo_url}" "/tmp/chaOS"
cp -r "/tmp/chaOS/config" "${config_dest}"
rm -rf "/tmp/chaOS"
