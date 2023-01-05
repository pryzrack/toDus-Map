cd "src/"

echo "optimized the icon..."

if [ ! -f "icon.png" ]; then
    echo "ICON NOT FOUND: You can include an icon to make your webxdc easier to recognize."
else
    IMG_CHARS=`identify "icon.png" | cut -f 3 -d' '`
    WIDTH=`echo $IMG_CHARS | cut -d'x' -f 1`
    HEIGHT=`echo $IMG_CHARS | cut -d'x' -f 2`
    if [ $WIDTH -gt 256 ] && [ $HEIGHT -gt 256 ]; then
        convert -resize 256 "icon.png" "icon.png"
    fi
    pngquant --quality 0-10 --speed 1 --skip-if-larger --ext ".png" --force "icon.png" "icon.png"
    echo "finished ok!"
fi
echo

# minified only the files without .min.json
if [ -d "assets/json/" ]; then
    cd "assets/json/"
    echo "minified the json files..."
    for json in *.json; do
        if ! echo "${json#*.}" | grep -q "min.json"; then
            echo ${json}
            if [ ! -f "${json%.*}.min.json" ]; then
                jq -c . "$json" > "${json%.*}.min.json"
            fi
        fi
    done
fi
echo "finished ok!"
