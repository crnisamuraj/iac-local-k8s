#!/usr/bin/env bash
set -xe
SOURCE=$1
OUTPUT=$2
SIZE_DISK=$3
SIZE_PART=$4

# Get information about the partitions in the source image
virt-filesystems --long -h --all -a "$SOURCE"

# Create a new destination image with the specified size increased in before script
# qemu-img create -f qcow2 "$OUTPUT" "${SIZE_DISK}"

# Get information about the partitions in the output image
virt-filesystems --long -h --all -a "$OUTPUT"

# Resize the first partition to use all available space
virt-resize --format raw --resize  "/dev/sda1=+$SIZE_PART" "$SOURCE" "$OUTPUT"

echo "Resized $SOURCE to $OUTPUT with size $SIZE_PART"