#!/usr/bin/env bash

# Unmount an image file mounted with usermount.sh

echo "Unmounting /dev/loop0"
umount /mnt/loop0 || echo "Couldn't unmount /mnt/loop0"
echo "Detaching /dev/loop0"
sync && sync && sync #  :)
losetup -d /dev/loop0 || echo "Couldn't detach /dev/loop0"
