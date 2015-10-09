#!/usr/bin/env bash
# Mount an image file without root.
# Assumes fstab contains the line:
#   "/dev/loop0 /mnt/loop0 auto noauto,loop,users 0 0"
#
# Sorry, this root-less mounting doesn't let you pass arguments like "-o ro".
set -v

image_file=$1

if [ ! -f $image_file ]; then
  echo "Couldn't find file $image_file"
  exit 1
fi

if [ ! -d /mnt/loop0 ]; then
  echo "/mnt/loop0 doesn't exist."
  exit 1
fi

sync
losetup /dev/loop0 $image_file && mount /mnt/loop0

if [ $? -eq 0 ]; then
  echo "Mounted $image_file on /mnt/loop0"
else
  echo "Couldn't mount $image_file on /mnt/loop0"
  exit 1
fi
