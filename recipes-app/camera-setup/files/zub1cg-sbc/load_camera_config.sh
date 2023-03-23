#!/bin/sh

case "$1" in
	"ar0144" | "ar1335" | "ar0830")
        echo "Loading Camera $1"
    ;;
	*)
		echo "Camera setup not supported: $1";
		exit 22
	;;
esac

# We need to umount boot if it has been previously mounted (EXT4 images) to allow for the different device-tree to be loaded
mountpoint -q /boot
BOOT_NOT_MOUNTED=$?

MOUNT_PATH=""

if [ $BOOT_NOT_MOUNTED -eq 0 ]
then
	MOUNT_PATH=$(findmnt --target /boot --noheadings -o SOURCE)
	umount /boot
fi

# The AP1302 I2C adresses is decided by its GPIO[11] pin (datasheet p.36 I2C Slave Interface):
# • GPIO[11] == 0: ID == 0x78
# • GPIO[11] == 1: ID == 0x7A
# At start up this GPIO is deasserted which causes the AP1302 to obtain the I2C adress 0x78. But later in
# the boot process the GPIO is asserted. If the AP1302 is reset (when loading the driver module for example)
# the ISP's I2C address will be changed to 0x7A and won't match the device-tree configurationi anymore.
# Thus, the driver will fail to load. To prevent this issue we manually set the GPIO value to 0 which
# will prevent the module probe to fail when loading the module after start up.
#
# The GPIO[11] is linked the XCZU3EG's IO_L12N_AD0N_26 pin. In the FPGA design the pin IO_L12N_AD0N_26
# is linked the output #1 of the axi_gpio_0 core at address 0xa0030000.
#
# root@u96v2-sbc-dualcam-2021-1:~# cat /sys/class/gpio/gpiochip500/label
# a0030000.gpio
# root@u96v2-sbc-dualcam-2021-1:~# cat /sys/class/gpio/gpiochip500/ngpio
# 8
source /usr/local/bin/gpio/gpio_common.sh

BASE_A0000000=$(get_gpiochip_base a0000000)
((AP1302_ID_GPIO=BASE_A0000000+1))
echo "   AP1302_ID GPIO = $AP1302_ID_GPIO"

echo $AP1302_ID_GPIO > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio$AP1302_ID_GPIO/direction
echo 0 > /sys/class/gpio/gpio$AP1302_ID_GPIO/value

mkdir -p /sys/kernel/config/device-tree/overlays/ap1302

if [ ! -e /boot/devicetree/$1.dtbo ]
then
	echo "/boot/devicetree/$1.dtbo: No such file or directory"
	exit 2
fi

cat /boot/devicetree/$1.dtbo > /sys/kernel/config/device-tree/overlays/ap1302/dtbo

# Remount /Boot if it was previously mounted
if [ $BOOT_NOT_MOUNTED -eq 0 ]
then
	mount $MOUNT_PATH /boot
fi
