#!/usr/bin/env bash
set -xe
SOURCE=$1
OUTPUT=$2
SIZE=$3

# Extract the numeric part and unit
SIZE_NUM=$(echo "$SIZE" | sed -E 's/([0-9]+)([A-Za-z]+)?/\1/')
SIZE_UNIT=$(echo "$SIZE" | sed -E 's/([0-9]+)([A-Za-z]+)?/\2/')
# Add 3 to the numeric value
NEW_SIZE=$((SIZE_NUM + 5))


# Create a new destination image with the specified size
qemu-img create -f qcow2 "$OUTPUT" "${NEW_SIZE}${SIZE_UNIT}"

# Get information about the partitions in the source image
virt-filesystems --long -h --all -a "$SOURCE"

# Resize the first partition to use all available space
virt-resize --resize "/dev/sda1=+$SIZE" "$SOURCE" "$OUTPUT"

echo "Resized $SOURCE to $OUTPUT with size $SIZE"