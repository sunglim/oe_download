#!/bin/bash

#mount -t smbfs //156.147.69.51/work /mnt/51server -o username=sungguk.lim
echo "* COPY"
rm hybridtv*.bz2;
rm hybridtv-atsc -rf;

FILENAME=$(ls -lrt /mnt/24server/hybridtv-atsc*.bz2 | awk -F" " '{ print $9 }')
cp $FILENAME ./
tar xvf hybridtv*.bz2
cp ./hybridtv-atsc/usr/lib/* ./usr/lib
