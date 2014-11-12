echo "* copy browser"
FILENAME=$(ls -lrt /mnt/51server/browser/htvbrowser/hybridtv/dist/LG1311C0/htvbrowser*.bz2 | awk -F" " '{ print $9 }')
cp $FILENAME ./mnt/lg/htvbrowser.tar.gz
rm -rf ./mnt/lg/htvbrowser;
tar xvf ./mnt/lg/htvbrowser.tar.gz -C ./mnt/lg
echo $FILENAME
