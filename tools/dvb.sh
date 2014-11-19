#!/bin/bash

#mount -t smbfs //156.147.69.51/work /mnt/51server -o username=sungguk.lim
echo "* COPY"
rm hybridtv*.bz2;
rm hybridtv-dvb -rf;

FILENAME=$(ls -lrt /mnt/24server/lg1311/sungguk.lim/hybridtv-dvb*.bz2 | head -1| awk -F" " '{ print $9 }')
cp $FILENAME ./
tar xvf hybridtv*.bz2
cp ./hybridtv-dvb/usr/lib/* ./usr/lib
