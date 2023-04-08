#!/usr/bin/env bash

set -euo pipefail

script_path="$(readlink -f "${0%/*}")"
work_dir="work"

log() {
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $*"
}

arch_chroot() {
	arch-chroot "${script_path}/${work_dir}/x86_64/airootfs" /bin/bash -c "${1}"
}

enable_services() {
	local services=(NetworkManager.service systemd-timesyncd.service bluetooth.service firewalld.service
		vboxservice.service vmtoolsd.service vmware-vmblock-fuse.service intel.service)
	for service in "${services[@]}"; do
		arch_chroot "systemctl enable ${service}"
	done
	arch_chroot "systemctl set-default multi-user.target"
}

install_packages() {
	local package_list=("grub" "eos-dracut" "kernel-install-for-dracut" "refind" "os-prober" "xf86-video-intel")
	arch_chroot "pacman -Sw --noconfirm --cachedir /usr/share/packages ${package_list[*]}"
}

do_merge() {
	arch_chroot "$(
		cat <<EOF
set -euo pipefail
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] \$*"
}

log "Starting chrooted commandlist"
cd "/root"

log "Initializing and populating keys"
pacman-key --init
pacman-key --populate archlinux chaos
pacman -Syy

log "Installing liveuser skel"
pacman -U --noconfirm --overwrite "/etc/skel/.bash_profile","/etc/skel/.bashrc" -- "/root/chaos-skel-liveuser/"*".pkg.tar.zst"

log "Preparing livesession settings and user"
sed -i 's/#\\(en_US\\.UTF-8\\)/\\1/' "/etc/locale.gen"
locale-gen
ln -sf "/usr/share/zoneinfo/UTC" "/etc/localtime"

log "Setting root permission and shell"
usermod -s /usr/bin/bash root

log "Creating liveuser"
useradd -m -p "" -g 'liveuser' -G 'sys,rfkill,wheel,uucp,nopasswdlogin,adm,tty' -s /bin/bash liveuser

log "Removing liveuser skel"
pacman -Rns --noconfirm -- "chaos-skel-liveuser"
rm -rf "/root/chaos-skel-liveuser"

log "Configuring root qt style for Calamares"
mkdir -p "/root/.config"
cp -Rf "/home/liveuser/.config/"{"Kvantum","qt5ct"} "/root/.config/"

log "Adding builddate to motd"
cat "/usr/lib/chaos-release" >> "/etc/motd"
echo "------------------" >> "/etc/motd"

log "Enabling systemd services"
enable_services

log "Installing locally built packages on ISO"
pacman -U --noconfirm -- "/root/packages/"*".pkg.tar.zst"
rm -rf "/root/packages/"

log "Setting wallpaper for live-session and original for installed system"
mv "chaos-wallpaper.png" "/etc/calamares/files/chaos-wallpaper.png"
mv "/root/livewall.png" "/usr/share/chaos/backgrounds/chaos-wallpaper.png"
chmod 644 "/usr/share/chaos/backgrounds/"*".png"

log "Applying temporary custom fixes"
cp -af "/home/liveuser/"{".bashrc",".bash_profile"} "/etc/skel/"

log "Moving blacklisting nouveau out of ISO"
mv "/usr/lib/modprobe.d/nvidia-utils.conf" "/etc/calamares/files/nv-modprobe"
mv "/usr/lib/modules-load.d/nvidia-utils.conf" "/etc/calamares/files/nv-modules-load"

log "Getting extra drivers"
mkdir "/opt/extra-drivers"
pacman -Syy
pacman -Sw --noconfirm --cachedir "/opt/extra-drivers" r8168

log "Installing packages"
install_packages

log "Cleaning pacman log and package cache"
rm "/var/log/pacman.log"
rm -rf "/var/cache/pacman/pkg/"

log "Applying calamares bug fix"
rm -rf /home/build

log "Creating package versions file"
local package_list=("calamares" "chromium" "linux" "mesa" "xorg-server" "nvidia-dkms")
for package in "${package_list[@]}"; do
    pacman -Qs | grep "/${package} " | cut -c7- >> iso_package_versions
done
mv "iso_package_versions" "/home/liveuser/"

log "Ending chrooted commandlist"
EOF
	)"

}

log "Starting commandlist"
do_merge
