#!/bin/bash

read -p "Target Tag ? [x.x.x] " targetTag

if ! echo $targetTag | grep -e ^Y[0-9]*[\.][0-9]*[\.][0-9]*$  ; then
    echo -e "\e[1;5;31m Invalid Target Tag \e[0m"
    exit 1
fi

#targetTag=1.0.1
dataFile=release/youtube_data_${targetTag}.dump

if [ "$fromRemote" = "Y" ] || [ "$fromRemote" = "y" ] ; then
    git fetch --all
fi

sudo su postgres -c "pg_dump --data-only -d origin_songs -t youtube_videos -O -f ~/youtube_data.dump"
cp -f /var/lib/postgresql/youtube_data.dump $dataFile

echo -e "\e[1;5;32m Output file is "$dataFile" \e[0m"

