#!/bin/bash

read -p "Source Tag ? [x.x.x] " sourceTag
read -p "Target Tag ? [x.x.x] " targetTag
read -p "From Remote Repositories (Y/N) ? [N]" fromRemote

if ! echo $sourceTag | grep -e ^[0-9]*[\.][0-9]*[\.][0-9]*$  ; then
    echo -e "\e[1;5;31m Invalid Source Tag \e[0m"
    exit 1
fi

if ! echo $targetTag | grep -e ^[0-9]*[\.][0-9]*[\.][0-9]*$  ; then
    echo -e "\e[1;5;31m Invalid Target Tag \e[0m"
    exit 1
fi

#sourceTag=1.0.0
#targetTag=1.0.1
sqlCmd=release/youtube_patch_${targetTag}.sql

echo "-- Target Tag : "$targetTag" --" > $sqlCmd
echo "-- Source Tag : "$sourceTag" --" >> $sqlCmd
echo "-- UTC : "$(date -u +"%F %T") >> $sqlCmd

if [ "$fromRemote" = "Y" ] || [ "$fromRemote" = "y" ] ; then
    git fetch --all
fi


# artists #################

git diff -U0 --output=release/youtube_videos_$targetTag $sourceTag $targetTag db/youtube_videos.csv 

grep -e ^-[1-9] release/youtube_videos_$targetTag | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM youtube_videos WHERE id = %d;\n", $1}' >> $sqlCmd

inserts=$(grep -c ^+[1-9] release/youtube_videos_$targetTag)

case "$inserts" in
    0) 
        echo "No YouTube Video Insert"
    ;;
    *) 
    grep -e ^+[1-9] release/youtube_videos_$targetTag \
    | sed 's/^+//g' \
    | awk -F"," '{printf "INSERT INTO youtube_videos (id, video_id, title, description, thumbnail, view_count, publish_time, updated_time, deleted, deleted_time, checked, checked_time, search_lexemes, artist, language, category, label, selected, selected_time, deleted_code, fuzzy_title) VALUES (%d,#@%s#@,#@%s#@,#@%s#@,#@%s#@,%d,#@%s#@,#@%s#@,%s,#@%s#@,%s,#@%s#@,#@%s#@,%d,%d,%d,%d,%s,#@%s#@,%d,#@%s#@);\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21}' >> $sqlCmd
    ;;
esac

##############
sed -i "s/#@#@/NULL/g" $sqlCmd
sed -i "s/,f,/,false,/g" $sqlCmd
sed -i "s/,t,/,true,/g" $sqlCmd
sed -i "s/,f)/,false)/g" $sqlCmd
sed -i "s/,t)/,true)/g" $sqlCmd
sed -i "s/'/''/g" $sqlCmd
sed -i "s/\`/''/g" $sqlCmd
sed -i "s/#@/'/g" $sqlCmd

echo -e "\e[1;5;32m Output file is "$sqlCmd" \e[0m"

