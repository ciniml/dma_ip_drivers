#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

DEVICES=`lspci | grep Xilinx | cut -f 1 -d ' '`

for d in $DEVICES; do cp /sys/bus/pci/devices/0000\:$d/config config.$d; done;
for d in $DEVICES; do echo 1 > /sys/bus/pci/devices/0000\:$d/remove; done;
rmmod xdma
read -p "Configure the target device"
for d in $DEVICES; do echo 1 > /sys/bus/pci/rescan; done;
for d in $DEVICES; do cp config.$d /sys/bus/pci/devices/0000\:$d/config; done;
for d in $DEVICES; do echo 1 > /sys/bus/pci/devices/0000\:$d/reset; done;
insmod xdma.ko