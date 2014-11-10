#!/bin/bash

#mount -t smbfs //156.147.69.51/work /mnt/51server -o username=sungguk.lim
echo "* COPY"
rm hybridtv*.bz2;
rm hybridtv-dvb -rf;
cp /mnt/24server/hybridtv-dvb*.bz2 ./
tar xvf hybridtv*.bz2
cp ./hybridtv-dvb/usr/lib/* ./usr/lib
