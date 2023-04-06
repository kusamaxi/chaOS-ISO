#!/usr/bin/env bash
irootfs/etc/environment

irootfs/etc/environment
# Made by Fernando "maroto"
irootfs/etc/environment
# Run anything in the filesystem right before being "mksquashed"
irootfs/etc/environment
# ISO-NEXT specific cleanup removals and additions (08-2021 + 10-2021) @killajoe and @manuel
irootfs/etc/environment
# refining and changes november 2021 @killajoe and @manuel
irootfs/etc/environment

irootfs/etc/environment
script_path=$(readlink -f "${0%/*}")
irootfs/etc/environment
work_dir="work"
irootfs/etc/environment

irootfs/etc/environment
# Adapted from AIS. An excellent bit of code!
irootfs/etc/environment
# all pathes must be in quotation marks "path/to/file/or/folder" for now.
irootfs/etc/environment

irootfs/etc/environment
arch_chroot() {
irootfs/etc/environment
    arch-chroot "${script_path}/${work_dir}/x86_64/airootfs" /bin/bash -c "${1}"
irootfs/etc/environment
}
irootfs/etc/environment

irootfs/etc/environment
do_merge() {
irootfs/etc/environment

irootfs/etc/environment
arch_chroot "$(cat << EOF
irootfs/etc/environment

irootfs/etc/environment
echo "##############################"
irootfs/etc/environment
echo "# start chrooted commandlist #"
irootfs/etc/environment
echo "##############################"
irootfs/etc/environment

irootfs/etc/environment
cd "/root"
irootfs/etc/environment

irootfs/etc/environment
# Init & Populate keys
irootfs/etc/environment
pacman-key --init
irootfs/etc/environment
pacman-key --populate archlinux chaos
irootfs/etc/environment
pacman -Syy
irootfs/etc/environment

irootfs/etc/environment
# Install liveuser skel (in case of conflicts use overwrite)
irootfs/etc/environment
pacman -U --noconfirm --overwrite "/etc/skel/.bash_profile","/etc/skel/.bashrc" -- "/root/chaos-skel-liveuser/"*".pkg.tar.zst"
irootfs/etc/environment

irootfs/etc/environment
# Prepare livesession settings and user
irootfs/etc/environment
sed -i 's/#\(en_US\.UTF-8\)/\1/' "/etc/locale.gen"
irootfs/etc/environment
locale-gen
irootfs/etc/environment
ln -sf "/usr/share/zoneinfo/UTC" "/etc/localtime"
irootfs/etc/environment

irootfs/etc/environment
# Set root permission and shell
irootfs/etc/environment
usermod -s /usr/bin/bash root
irootfs/etc/environment

irootfs/etc/environment
# Create liveuser
irootfs/etc/environment
useradd -m -p "" -g 'liveuser' -G 'sys,rfkill,wheel,uucp,nopasswdlogin,adm,tty' -s /bin/bash liveuser
irootfs/etc/environment

irootfs/etc/environment
# Remove liveuser skel to then install user skel
irootfs/etc/environment
pacman -Rns --noconfirm -- "chaos-skel-liveuser"
irootfs/etc/environment
rm -rf "/root/chaos-skel-liveuser"
irootfs/etc/environment

irootfs/etc/environment
# Root qt style for Calamares
irootfs/etc/environment
mkdir "/root/.config"
irootfs/etc/environment
cp -Rf "/home/liveuser/.config/"{"Kvantum","qt5ct"} "/root/.config/"
irootfs/etc/environment

irootfs/etc/environment
# Add builddate to motd:
irootfs/etc/environment
cat "/usr/lib/chaos-release" >> "/etc/motd"
irootfs/etc/environment
echo "------------------" >> "/etc/motd"
irootfs/etc/environment

irootfs/etc/environment
# Enable systemd services
irootfs/etc/environment
systemctl enable NetworkManager.service systemd-timesyncd.service bluetooth.service firewalld.service
irootfs/etc/environment
systemctl enable vboxservice.service vmtoolsd.service vmware-vmblock-fuse.service
irootfs/etc/environment
systemctl set-default multi-user.target
irootfs/etc/environment
systemctl enable intel.service
irootfs/etc/environment

irootfs/etc/environment
# Install locally builded packages on ISO (place packages under airootfs/root/packages)
irootfs/etc/environment
pacman -U --noconfirm -- "/root/packages/"*".pkg.tar.zst"
irootfs/etc/environment
rm -rf "/root/packages/"
irootfs/etc/environment

irootfs/etc/environment
# Set wallpaper for live-session and original for installed system
irootfs/etc/environment
mv "chaos-wallpaper.png" "/etc/calamares/files/chaos-wallpaper.png"
irootfs/etc/environment
mv "/root/livewall.png" "/usr/share/chaos/backgrounds/chaos-wallpaper.png"
irootfs/etc/environment
chmod 644 "/usr/share/chaos/backgrounds/"*".png"
irootfs/etc/environment
#test to use the new xfce4-desktop.xml file
irootfs/etc/environment
#rm -rf "/usr/share/backgrounds/xfce/xfce-verticals.png"
irootfs/etc/environment
#ln -s "/usr/share/chaos/backgrounds/chaos-wallpaper.png" "/usr/share/backgrounds/xfce/xfce-verticals.png"
irootfs/etc/environment

irootfs/etc/environment

irootfs/etc/environment
# TEMPORARY CUSTOM FIXES
irootfs/etc/environment

irootfs/etc/environment
# Fix for getting bash configs installed
irootfs/etc/environment
cp -af "/home/liveuser/"{".bashrc",".bash_profile"} "/etc/skel/"
irootfs/etc/environment

irootfs/etc/environment
# Move blacklisting nouveau out of ISO (copy back to target for offline installs)
irootfs/etc/environment
mv "/usr/lib/modprobe.d/nvidia-utils.conf" "/etc/calamares/files/nv-modprobe"
irootfs/etc/environment
mv "/usr/lib/modules-load.d/nvidia-utils.conf" "/etc/calamares/files/nv-modules-load"
irootfs/etc/environment

irootfs/etc/environment
# Get extra drivers!
irootfs/etc/environment
mkdir "/opt/extra-drivers"
irootfs/etc/environment
pacman -Syy
irootfs/etc/environment
pacman -Sw --noconfirm --cachedir "/opt/extra-drivers" r8168
irootfs/etc/environment

irootfs/etc/environment
# install packages
irootfs/etc/environment
mkdir -p "/usr/share/packages"
irootfs/etc/environment
pacman -Sw --noconfirm --cachedir "/usr/share/packages" grub eos-dracut kernel-install-for-dracut refind os-prober xf86-video-intel
irootfs/etc/environment

irootfs/etc/environment
# Clean pacman log and package cache
irootfs/etc/environment
rm "/var/log/pacman.log"
irootfs/etc/environment
# pacman -Scc seem to fail so:
irootfs/etc/environment
rm -rf "/var/cache/pacman/pkg/"
irootfs/etc/environment

irootfs/etc/environment
#calamares BUG https://github.com/calamares/calamares/issues/2075
irootfs/etc/environment
rm -rf /home/build
irootfs/etc/environment

irootfs/etc/environment
#create package versions file
irootfs/etc/environment
pacman -Qs | grep "/calamares " | cut -c7- > iso_package_versions
irootfs/etc/environment
pacman -Qs | grep "/chromium " | cut -c7- >> iso_package_versions
irootfs/etc/environment
pacman -Qs | grep "/linux " | cut -c7- >> iso_package_versions
irootfs/etc/environment
pacman -Qs | grep "/mesa " | cut -c7- >> iso_package_versions
irootfs/etc/environment
pacman -Qs | grep "/xorg-server " | cut -c7- >> iso_package_versions
irootfs/etc/environment
pacman -Qs | grep "/nvidia-dkms " | cut -c7- >> iso_package_versions
irootfs/etc/environment
mv "iso_package_versions" "/home/liveuser/"
irootfs/etc/environment

irootfs/etc/environment
echo "############################"
irootfs/etc/environment
echo "# end chrooted commandlist #"
irootfs/etc/environment
echo "############################"
irootfs/etc/environment

irootfs/etc/environment
EOF
irootfs/etc/environment
)"
irootfs/etc/environment
}
irootfs/etc/environment

irootfs/etc/environment
#################################
irootfs/etc/environment
########## STARTS HERE ##########
irootfs/etc/environment
#################################
irootfs/etc/environment

irootfs/etc/environment
do_merge
irootfs/etc/environment
