#!/bin/bash

#mount -t smbfs //156.147.61.35/tftpboot /mnt/35server -o username=sungguk.lim
echo "* COPY"
rm hybridtv*.bz2;
rm hybridtv-atsc -rf;

FILENAME=$(ls -lrt /mnt/24server/lg1311/sungguk.lim/hybridtv-atsc*.bz2 | head -1| awk -F" " '{ print $9 }')
cp $FILENAME ./
tar xvf hybridtv*.bz2
cp ./hybridtv-atsc/usr/lib/* ./usr/lib
