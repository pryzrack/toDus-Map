#!/bin/sh

case "$1" in
    "-h" | "--help")
        echo "usage: ${0##*/} [PACKAGE_NAME]"
        exit
        ;;
    "")
        PACKAGE_NAME=${PWD##*/} # '##*/' removes everything before the last slash and the last slash
        ;;
    *)
        PACKAGE_NAME=${1%.xdc} # '%.xdc' removes the extension and allows PACKAGE_NAME to be given with or without extension
        ;;
esac

rm "dest/$PACKAGE_NAME.xdc" 2> /dev/null
cd src
zip -9 -r "../dest/$PACKAGE_NAME.xdc" * --exclude eruda.min.js assets/json/prototype.json

echo "success, archive contents:"
unzip -l "../dest/$PACKAGE_NAME.xdc"

# check package size
MAXSIZE=655360
size=$(wc -c < "../dest/$PACKAGE_NAME.xdc")
if [ $size -ge $MAXSIZE ]; then
    echo "WARNING: package size exceeded the limit ($size > $MAXSIZE)"
fi
