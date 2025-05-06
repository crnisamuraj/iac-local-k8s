#!/usr/bin/env bash
set -xe
SOURCE=$1
OUTPUT=$2
SIZE_DISK=$3
SIZE_PART=$4

# Extract the numeric part and unit
# SIZE_NUM=$(echo "$SIZE" | sed -E 's/([0-9]+)([A-Za-z]+)?/\1/')
# SIZE_UNIT=$(echo "$SIZE" | sed -E 's/([0-9]+)([A-Za-z]+)?/\2/')
# Add 3 to the numeric value
# NEW_SIZE=$((SIZE_NUM + 5))

# Get information about the partitions in the source image
virt-filesystems --long -h --all -a "$SOURCE"

# Create a new destination image with the specified size increased in script
#qemu-img create -f qcow2 "$OUTPUT" "${NEW_SIZE}${SIZE_UNIT}"

# Create a new destination image with the specified size increased in before script
qemu-img create -f qcow2 "$OUTPUT" "${SIZE_DISK}"

# Get information about the partitions in the output image
virt-filesystems --long -h --all -a "$OUTPUT"

# Resize the first partition to use all available space
virt-resize --resize "/dev/sda1=+$SIZE_PART" "$SOURCE" "$OUTPUT"

echo "Resized $SOURCE to $OUTPUT with size $SIZE_PART"