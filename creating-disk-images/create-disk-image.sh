CREATE_DISK_IMAGES=/home/isaar/Documents/creating-disk-images
cd /home/isaar/Documents/gem5/

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
#
