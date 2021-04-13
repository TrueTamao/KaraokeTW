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

#sourceTag=0.12.1
#targetTag=0.12.2
sqlCmd=release/cloud_patch_${targetTag}.sql

echo "## Target Tag : "$targetTag" ##" > $sqlCmd
echo "## Source Tag : "$sourceTag" ##" >> $sqlCmd
echo "## UTC : "$(date -u +"%F %T") >> $sqlCmd

if [ "$fromRemote" = "Y" ] || [ "$fromRemote" = "y" ] ; then
    git fetch --all
fi


# artists #################

git diff -U0 --output=release/origin_artists_$targetTag $sourceTag $targetTag db/origin_artists.csv 

inserts=$(grep -c ^+[1-9] release/origin_artists_$targetTag)

case "$inserts" in
    0) 
        echo "No Artist Insert"
    ;;
    *) 
    grep -e ^+[1-9] release/origin_artists_$targetTag \
    | sed 's/^+//g' \
    | awk -F"|" '{printf "psql -d song -c \"INSERT INTO artists (sn,name,category,country,updated_time,deleted,deleted_time) VALUES (%d,@%s@,%d,%d,@%s@,%s,@%s@) ON CONFLICT (sn) DO UPDATE SET name=EXCLUDED.name,category=EXCLUDED.category,country=EXCLUDED.country,updated_time = EXCLUDED.updated_time,deleted=EXCLUDED.deleted,deleted_time=EXCLUDED.deleted_time;\"; echo %d;\n",$1,$2,$3,$4,$6,$7,$8,$1}' >> $sqlCmd
    ;;
esac

# labels #################

git diff -U0 --output=release/labels_$targetTag $sourceTag $targetTag db/labels.csv 

inserts=$(grep -c ^+[1-9] release/labels_$targetTag)

case "$inserts" in
    0) 
        echo "No Label Insert"
    ;;
    *) 
    grep -e ^+[1-9] release/labels_$targetTag \
    | sed 's/^+//g' \
    | awk -F"|" '{printf "psql -d song -c \"INSERT INTO labels (sn,name,updated_time,deleted,deleted_time,association) VALUES (%d,@%s@,@%s@,%s,@%s@,%d) ON CONFLICT (sn) DO UPDATE SET name=EXCLUDED.name,updated_time = EXCLUDED.updated_time,deleted=EXCLUDED.deleted,deleted_time=EXCLUDED.deleted_time,association=EXCLUDED.association;\"; echo %d;\n",$1,$3,$4,$5,$6,$7,$1}' >> $sqlCmd
    ;;
esac

# songs #################

git diff -U0 --output=release/origin_songs_$targetTag $sourceTag $targetTag db/origin_songs.csv 

inserts=$(grep -c ^+[1-9] release/origin_songs_$targetTag)

case "$inserts" in
    0)
        echo "No Song Insert"
    ;;
    *)
    grep -e ^+[1-9] release/origin_songs_$targetTag \
    | sed 's/^+//g' \
    | awk -F"|" '{printf "psql -d song -c \"INSERT INTO songs (sn,kjbcode,isrc,name,artist,language,category,label,loudness,vocal,release_date,updated_time,deleted,deleted_time,youtube,youtube_karaoke) VALUES (%d,@%s@,@%s@,@%s@,%d,%d,%d,%d,%.1f,%d,@%s@,@%s@,%s,@%s@,@%s@,@%s@) ON CONFLICT (sn) DO UPDATE SET kjbcode=EXCLUDED.kjbcode,isrc=EXCLUDED.isrc,name=EXCLUDED.name,artist=EXCLUDED.artist,language=EXCLUDED.language,category=EXCLUDED.category,label=EXCLUDED.label,loudness=EXCLUDED.loudness,vocal=EXCLUDED.vocal,release_date=EXCLUDED.release_date,updated_time=EXCLUDED.updated_time,deleted=EXCLUDED.deleted,deleted_time=EXCLUDED.deleted_time,youtube=EXCLUDED.youtube,youtube_karaoke=EXCLUDED.youtube_karaoke;\"; echo %d;\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$16,$18,$19,$20,$21,$22,$1}' >> $sqlCmd
    ;;
    esac

##############
sed -i "s/'/''/g" $sqlCmd
sed -i "s/@@/NULL/g" $sqlCmd
sed -i "s/@/'/g" $sqlCmd
sed -i "s/,f,/,false,/g" $sqlCmd
sed -i "s/,t,/,true,/g" $sqlCmd

echo -e "\e[1;5;32m Output file is "$sqlCmd" \e[0m"

