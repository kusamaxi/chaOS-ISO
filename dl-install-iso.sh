#!/bin/bash
set -euo pipefail

log() {
	echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 TORRENT_URL SIGNING_KEY_FINGERPRINT"
	exit 1
fi

TORRENT_URL="$1"
SIGNING_KEY_FINGERPRINT="$2"

# Parse filenames from the torrent URL
ISO_FILE="${TORRENT_URL%%.torrent}.iso"
SHA512SUM_FILE="${TORRENT_URL%%.torrent}.iso.sha512sum"
SIG_FILE="${TORRENT_URL%%.torrent}.iso.sig"

log "Downloading the torrent, signature, and sha512sum files"
wget -q --show-progress "${TORRENT_URL}"
wget -q --show-progress "${TORRENT_URL%%.torrent}.sig"
wget -q --show-progress "${TORRENT_URL%%.torrent}.sha512sum"

log "Downloading the ISO using the torrent file"
aria2c --seed-time=0 --summary-interval=30 --file-allocation=none -d "$(dirname "${ISO_FILE}")" "${TORRENT_URL##*/}"

log "Importing signing key"
gpg --keyserver keyserver.ubuntu.com --recv-keys "${SIGNING_KEY_FINGERPRINT}"

log "Verifying the ISO file signature"
gpg --verify "${SIG_FILE}" "${ISO_FILE}"

if [ $? -eq 0 ]; then
	log "ISO signature is valid."
else
	log "ISO signature is invalid. Exiting..."
	exit 1
fi

log "Checking sha512sum..."
sha512sum -c "${SHA512SUM_FILE}"

if [ $? -eq 0 ]; then
	log "sha512sum is correct."
else
	log "sha512sum is incorrect. Exiting..."
	exit 1
fi

log "Listing available USB disks:"
lsblk -d -p -o NAME,SIZE,MODEL | grep -v "NAME"

read -p "Enter the full path of the USB disk to install the ISO (e.g. /dev/sdb): " USB_DISK

read -p "You have chosen $USB_DISK. This will erase all data on the disk. Are you sure? [y/N]: " CONFIRMATION
if [[ $CONFIRMATION =~ ^[Yy]$ ]]; then
	log "Unmounting the USB disk..."
	umount "${USB_DISK}"?* 2>/dev/null

	log "Writing the ISO to the USB disk..."
	sudo dd bs=4M if="${ISO_FILE}" of="${USB_DISK}" status=progress oflag=sync

	log "ISO has been successfully written to the USB disk."
else
	log "Aborted. No changes were made to the USB disk."
	exit 0
fi
