#!/bin/bash

#mount -t smbfs //156.147.69.51/work /mnt/51server -o username=sungguk.lim
echo "* COPY"
rm hybridtv*.bz2;
rm hybridtv-atsc -rf;
cp /mnt/24server/*.bz2 ./
tar xvf hybridtv*.bz2
cp ./hybridtv-atsc/usr/lib/* ./usr/lib
