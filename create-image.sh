#!/bin/bash

set -e

log() {
	echo "[$(date +"%Y-%m-%dT%H:%M:%S")] $1"
}

check_dependencies() {
	for cmd in aria2c gpg sha512sum; do
		if ! command -v "$cmd" &>/dev/null; then
			log "Error: $cmd not found. Please install it before running this script."
			exit 1
		fi
	done
}

prepare() {
	log "Preparing for ISO creation"
	./prepare.sh
}

build_iso() {
	log "Building the ISO"
	ISO_VERSION="$1"
	ISO_DATE=$(date -u +'%y%m%d%H%M')
	ISO_FILENAME="chaOS-${ISO_VERSION}-${ISO_DATE}.iso"
	sudo ./mkarchiso -v -o "../${ISO_FILENAME}" "."
}

create_torrent() {
	log "Creating torrent"
	cd ..
	aria2c --bt-metadata-only=true --bt-save-metadata=true -o "${ISO_FILENAME}.torrent" "file:///${ISO_FILENAME}"
}

create_sha512() {
	log "Creating SHA512 hash"
	sha512sum "${ISO_FILENAME}" >"${ISO_FILENAME}.sha512sum"
}

sign_files() {
	log "Signing torrent and SHA512 hash"
	gpg --detach-sign --armor "${ISO_FILENAME}.torrent"
	gpg --detach-sign --armor "${ISO_FILENAME}.sha512sum"
}

share_torrent() {
	log "Starting to share the torrent with aria2c in the background"
	aria2c --seed-time=0 --enable-dht --dht-listen-port=6881 --listen-port=6881 "${ISO_FILENAME}.torrent"

	log "Torrent sharing has started using aria2c."
}

main() {
	if [ -z "$1" ]; then
		echo "Usage: $0 <ISO_VERSION>"
		exit 1
	fi

	check_dependencies
	prepare
	build_iso "$1"
	create_torrent
	create_sha512
	sign_files
	share_torrent

	log "Finished creating and signing the ISO, torrent, and SHA512 hash."
}

main "$@"
