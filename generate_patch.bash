#!/bin/bash

read -p "Source Tag ? [x.x.x] " sourceTag
read -p "Target Tag ? [x.x.x] " targetTag
read -p "From Remote Repositories (Y/N) ? [N]" fromRemote

if ! echo $sourceTag | grep -e ^[0]*[\.][0-9]*[\.][0-9]*$  ; then
    echo -e "\e[1;5;31m Invalid Source Tag \e[0m"
    exit 1
fi

if ! echo $targetTag | grep -e ^[0]*[\.][0-9]*[\.][0-9]*$  ; then
    echo -e "\e[1;5;31m Invalid Target Tag \e[0m"
    exit 1
fi

sqlCmd=release/patch_${targetTag}.sql

echo "--"$targetTag"--" > $sqlCmd
echo "BEGIN;" >> $sqlCmd

if [ "$fromRemote" = "Y" ] || [ "$fromRemote" = "y" ] ; then
    git fetch --all
fi

git diff -U0 --output=release/songs_$targetTag $sourceTag $targetTag db/songs.csv 

grep -e ^-[1-9] release/songs_$targetTag | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM raw_songs WHERE sn = %d;\n", $1}' >> $sqlCmd

inserts=$(grep -c ^+[1-9] release/songs_$targetTag)

case "$inserts" in
    0) 
        echo "No Song Inserts"
    ;;
    1) 
        grep -e ^+[1-9] release/songs_$targetTag \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO raw_songs \
(sn, name, fuzzy_name, word_count, path, kjbcode, language, category, artist_sn, loudness, vocal_channel, youtube) VALUES \
( %d, \"%s\", \"%s\", %d, \"%s\", \"%s\", %d, %d, %d, %d, %d, \"%s\");\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' >> $sqlCmd
    ;;
    *) 
    printf "INSERT INTO raw_songs (sn, name, fuzzy_name, word_count, path, kjbcode, language, category, artist_sn, loudness, vocal_channel, youtube) VALUES \n" >> $sqlCmd
    grep -e ^+[1-9] release/songs_$targetTag \
| sed 's/^+//g' | awk -F"|" '{printf "( %d, \"%s\", \"%s\", %d, \"%s\", \"%s\", %d, %d, %d, %d, %d, \"%s\"),\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' >> $sqlCmd
	sed -i '$ s/,$/;/'  $sqlCmd
;;
esac


#################

git diff -U0 --output=release/artists_$targetTag $sourceTag $targetTag db/artists.csv 

grep -e ^-[1-9] release/artists_$targetTag | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM raw_artists WHERE sn = %d;\n", $1}' >> $sqlCmd

inserts=$(grep -c ^+[1-9] release/artists_$targetTag)

case "$inserts" in
    0) 
        echo "No Artist Insert"
    ;;
    1) 
        grep -e ^+[1-9] release/artists_$targetTag \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO raw_artists \
(sn, name, fuzzy_name, word_count, category, country, picture) VALUES \
( %d, \"%s\", \"%s\", %d, %d, %d, \"%s\");\n", $1, $2, $3, $4, $5, $6, $7}' >> $sqlCmd
    ;;
    *) 
    printf "INSERT INTO raw_artists (sn, name, fuzzy_name, word_count, category, country, picture) VALUES \n" >> $sqlCmd
    grep -e ^+[1-9] release/artists_$targetTag \
| sed 's/^+//g' | awk -F"|" '{printf "( %d, \"%s\", \"%s\", %d, %d, %d, \"%s\"),\n", $1, $2, $3, $4, $5, $6, $7}' >> $sqlCmd
sed -i '$ s/,$/;/'  $sqlCmd
;;
esac

#################

git diff -U0 --output=release/song_categories_$targetTag $sourceTag $targetTag db/song_categories.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/song_categories_$targetTag | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM song_categories WHERE sn = %d;\n", $1}' >> $sqlCmd

grep -e ^+[1-9] release/song_categories_$targetTag \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO song_categories \
(sn, name, priority) VALUES \
( %d, \"%s\", %d);\n", $1, $2}' >> $sqlCmd

###############

git diff -U0 --output=release/song_languages_$targetTag $sourceTag $targetTag db/song_languages.csv 

grep -e ^-[1-9] release/song_languages_$targetTag | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM song_languages WHERE sn = %d;\n", $1}' >> $sqlCmd

grep -e ^+[1-9] release/song_languages_$targetTag \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO song_languages \
(sn, name, priority) VALUES \
( %d, \"%s\", %d);\n", $1, $2, $3}' >> $sqlCmd

#################

git diff -U0 --output=release/artist_categories_$targetTag $sourceTag $targetTag db/artist_categories.csv 

grep -e ^-[1-9] release/artist_categories_$targetTag | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM artist_categories WHERE sn = %d;\n", $1}' >> $sqlCmd

grep -e ^+[1-9] release/artist_categories_$targetTag \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO artist_categories \
(sn, name, priority) VALUES \
( %d, \"%s\", %d);\n", $1, $2, $3}' >> $sqlCmd

#################

git diff -U0 --output=release/artist_countries_$targetTag $sourceTag $targetTag db/artist_countries.csv 

grep -e ^-[1-9] release/artist_countries_$targetTag | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM artist_countries WHERE sn = %d;\n", $1}' >> $sqlCmd

grep -e ^+[1-9] release/artist_countries_$targetTag \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO artist_countries \
(sn, name, priority) VALUES \
( %d, \"%s\", %d);\n", $1, $2, $3}' >> $sqlCmd

##############

echo $targetTag | awk -F"." '{printf "UPDATE versions SET major = %d, minor = %d, patch = %d WHERE name = \"song\";\n", $1, $2, $3}' >> $sqlCmd
echo "COMMIT;" >> $sqlCmd
echo "VACUUM;" >> $sqlCmd

sed -i "s/, \"\"\"\",/, \"\",/g" $sqlCmd
sed -i "s/, \"\"3'07\"\"\"\",/, \"3'07\"\"\",/g" $sqlCmd


cp $sqlCmd release/patch.sql

echo -e "\e[1;5;32m Output file is "$sqlCmd" \e[0m"

