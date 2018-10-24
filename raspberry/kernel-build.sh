# Author: Isaar Ahmad
# Update : 24.Oct.2018
# This scripts cross compiles and builds Linux kernel for Rpi 3 (Broadcom 2709), Raspbian OS(installed with NOOBS):
# References:
# https://www.raspberrypi.org/documentation/linux/kernel/building.md

########################################################################
RPI_SOURCE_PATH=$(pwd)/RpiSource

# if RpiSource folder is not present in current directory, clone it from git
if [ ! -d "${RPI_SOURCE_PATH}" ]; then 
	git clone -b rpi-4.14.y --single-branch https://github.com/raspberrypi/linux RpiSource
fi

# All the following commands are run from the current folder which is supposed to contain RpiSource folder
if [ ! -d "${RPI_SOURCE_PATH}" ]; then 
	exit
fi
# if PATH doesnt contain path to gcc cross compiler, update it in bashrc, and refresh
if [[ ${PATH} != *"arm-bcm2708/gcc-linaro-arm-linux"* ]]; then
	echo PATH=\$PATH:${RPI_SOURCE_PATH}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin >> ~/.bashrc
	source ~/.bashrc
fi


cd ${RPI_SOURCE_PATH}
KERNEL=kernel7
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs -j6

###################################################################
# Next part of script mounts and installs this kernel onto OS's file system. It assumes file system is mounted at /dev/sdb*.
# For NOOBS installation, you will have /dev/sdb6(boot, fat32), /dev/sdb7(root, ext4)
# Check whether Raspbian's file system is mounted(at /dev/sdb*)
# If not mounted, then exit

if grep -qs '/dev/sdb6' /proc/mounts; then
	echo "Raspbian boot found at /dev/sdb6"	
else
	echo "Raspbian boot not found. Exiting . . ."
	exit
fi

if grep -qs '/dev/sdb7' /proc/mounts; then
	echo "Raspbian root found at /dev/sdb7"
else
	echo "Raspbian root not found. Exiting . . ."
	exit
fi
mkdir mnt
mkdir mnt/fat32
mkdir mnt/ext4
sudo mount /dev/sdb6 mnt/fat32
sudo mount /dev/sdb7 mnt/ext4

# install kernel modules on mounted filesystem
sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=mnt/ext4 modules_install

sudo cp mnt/fat32/$KERNEL.img mnt/fat32/$KERNEL-backup.img
sudo cp arch/arm/boot/zImage mnt/fat32/$KERNEL.img
sudo cp arch/arm/boot/dts/*.dtb mnt/fat32/
sudo cp arch/arm/boot/dts/*.dtb* mnt/fat32/overlays/
sudo cp arch/arm/boot/dts/overlays/README mnt/fat32/overlays/

#unmount filesystems
sudo umount mnt/fat32
sudo umount mnt/ext4

# cleanup mnt points
rm -r mnt/fat32
rm -r mnt/ext4
rm -r mnt
