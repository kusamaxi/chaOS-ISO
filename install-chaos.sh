#!/bin/bash

ISO_FILE="EndeavourOS_Cassini_Nova-03-2023_R1.iso"
SHA512SUM_FILE="EndeavourOS_Cassini_Nova-03-2023_R1.iso.sha512sum"
SIG_FILE="EndeavourOS_Cassini_Nova-03-2023_R1.iso.sig"
TORRENT_FILE="EndeavourOS_Cassini_Nova-03-2023_R1.iso.torrent"

# Import EndeavourOS signing key
gpg --keyserver keyserver.ubuntu.com --recv-keys 497AF50C92AD2384C56E1ACA003DB8B0CB23504F

# Verify the ISO file signature
gpg --verify $SIG_FILE $ISO_FILE

# Check if the signature verification is successful
if [ $? -eq 0 ]; then
    echo "ISO signature is valid."
else
    echo "ISO signature is invalid. Exiting..."
    exit 1
fi

# Verify the sha512sum
echo "Checking sha512sum..."
sha512sum -c $SHA512SUM_FILE

# Check if the sha512sum is correct
if [ $? -eq 0 ]; then
    echo "sha512sum is correct."
else
    echo "sha512sum is incorrect. Exiting..."
    exit 1
fi

# List available USB disks
echo "Listing available USB disks:"
lsblk -d -p -o NAME,SIZE,MODEL | grep -v "NAME"

# Ask user for the USB disk to install the ISO
read -p "Enter the full path of the USB disk to install the ISO (e.g. /dev/sdb): " USB_DISK

# Confirm user input
read -p "You have chosen $USB_DISK. This will erase all data on the disk. Are you sure? [y/N]: " CONFIRMATION
if [[ $CONFIRMATION =~ ^[Yy]$ ]]; then
    echo "Unmounting the USB disk..."
    umount $USB_DISK?* 2> /dev/null

    echo "Writing the ISO to the USB disk..."
    sudo dd bs=4M if=$ISO_FILE of=$USB_DISK status=progress oflag=sync

    echo "ISO has been successfully written to the USB disk."
else
    echo "Aborted. No changes were made to the USB disk."
    exit 0
fi
