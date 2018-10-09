This utility creates a Full system ready disk image for use with gem5 FS mode.

I have followed the tutorial at:
http://www.lowepower.com/jason/creating-disk-images-for-gem5.html

How to use:
Place this folder alongside gem5's installation as follows:
path-to-gem5/
|		
---->gem5/
|
---->create-disk-images/

Now change directory into create-disk-images and run ./create-disk-images.sh

Note: you may encounter an error at the end, while unmounting the image. A workaround is given as comments in the script 'create-disk-images.sh' itself.
