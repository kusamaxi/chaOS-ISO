#!/bin/sh
rm -rf "work" "out"
rm airootfs/root/packages/*.pkg.tar.zst
rm airootfs/root/packages/*.pkg.tar.zst.sig
rm -rf airootfs/root/chaos-skel-liveuser/pkg
rm airootfs/root/chaos-wallpaper.png
rm airootfs/root/chaos-skel-liveuser/*.pkg.tar.zst
rm -rf airootfs/etc/pacman.d/
rm eosiso*.log
