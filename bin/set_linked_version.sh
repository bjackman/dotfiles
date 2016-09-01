#!/bin/bash

#
# This is for when I've got a TFTP server serving kernels to an external device,
# and I've got several kernel trees and I want to switch between them.
#
# Copy or link it to the directory where your TFTP server serves from.
#
# Say I've got ~/sources/linux-4.4 and ~/sources/linux-4.7, I'll run
# $TFTP_DIR/set_linked_version 4.7 then hit reset on the TFTP-enabled device and
# then party on with a v4.7 kernel.
#

set -eu

SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})

TARGET_DIR=~/sources/linux-$1

if [ ! -d $TARGET_DIR ]; then
   echo No such dir $TARGET_DIR
   exit 1
fi

ln -sf $TARGET_DIR/arch/arm64/boot/dts/arm/juno.dtb $SCRIPT_DIR
ln -sf $TARGET_DIR/arch/arm64/boot/Image $SCRIPT_DIR

ls -l $SCRIPT_DIR
