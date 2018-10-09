#if your path to gem5 is "/path-to-gem5/gem5"
#then place this folder in "/path-to/gem5/"
#then set CREATE_DISK_IMAGES=/path-to-gem5/creating-disk-images
PATH_TO_GEM5=
CREATE_DISK_IMAGES=${PATH_TO_GEM5}/creating-disk-images
cd ${PATH_TO_GEM5}/gem5

# init 4 GB image file
util/gem5img.py init ubuntu-test.img 4096

#create mount point for image
mkdir mnt
util/gem5img.py mount ubuntu-test.img mnt

#extract ubuntu-core-14.10 image onto mount point
sudo tar xzvf ${CREATE_DISK_IMAGES}/ubuntu-core-14.10-core-amd64.tar.gz -C mnt

#copy required files from your own system disk to new mounted disk
sudo cp /etc/resolv.conf mnt/etc/
sudo cp ${CREATE_DISK_IMAGES}/tty-gem5.conf mnt/etc/init/
sudo cp ${CREATE_DISK_IMAGES}/hosts mnt/etc/
sudo cp ${CREATE_DISK_IMAGES}/fstab mnt/etc/

#make m5 binary in host and copy m5 binary to disk
cd util/m5
make -f Makefile.x86
cd ../..
sudo cp util/m5/m5 mnt/sbin/
#unmount image finally
util/gem5img.py umount mnt
sudo umount mnt

###
#
# remove recently created loopback device from /dev/ using losetup, example:
# sudo losetup -d /dev/loop0 (if loop0 was the loopback device created when the image was mounted)
# you can check this with shell command: "ls /dev/ -lrt | grep loop"
# This command shows list of loopback devices. 
# Delete one with the most recent date/time of modification (nearly the same date/time as when you ran this script).
