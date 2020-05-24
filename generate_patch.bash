#!/bin/bash

patch=./release/patch.db

git diff -U0 --output=release/patch_0.0.2 0.0.1 0.0.4 db/origin_songs.csv 

grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM songs WHERE sn = %d;\n", $1}' > patch_0.0.2.cmd

grep -e ^+[1-9] release/patch_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO songs \
(sn, name, fuzzy_name, word_count, path, kjbcode, language, category, artist_sn, artist_name, artist_fuzzy_name, loudness, vocal_channel) VALUES \
( %d, \"%s\", \"%s\", %d, \" %s\", \"%s\", %d, %d, %d, \"%s\", \"%s\", %d, %d);\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' >>  patch_0.0.2.cmd

#################

git diff -U0 --output=release/artists_0.0.2 0.0.1 0.0.2 db/origin_artists.csv 

grep -e ^-[1-9] release/artists_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM artists WHERE sn = %d;\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/artists_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO artists \
(sn, name, fuzzy_name, word_count, category, country, path) VALUES \
( %d, \"%s\", \"%s\", %d, %d, %d, \" %s\");\n", $1, $2, $3, $4, $5, $6, $7}' >>  patch_0.0.2.cmd

#################

git diff -U0 --output=release/song_categories_0.0.2 0.0.1 0.0.2 db/origin_song_categories.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/song_categories_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM song_categories WHERE sn = %d;\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/song_categories_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO song_categories \
(sn, name, priority) VALUES \
( %d, \"%s\", %d);\n", $1, $2}' >>  patch_0.0.2.cmd

###############

git diff -U0 --output=release/song_languages_0.0.2 0.0.1 0.0.2 db/origin_song_languages.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/song_languages_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM song_languages WHERE sn = %d;\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/song_languages_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO song_languages \
(sn, name, priority) VALUES \
( %d, \"%s\", %d);\n", $1, $2, $3}' >>  patch_0.0.2.cmd

#################

git diff -U0 --output=release/artist_categories_0.0.2 0.0.1 0.0.2 db/origin_artist_categories.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/artist_categories_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM artist_categories WHERE sn = %d;\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/artist_categories_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO artist_categories \
(sn, name, priority) VALUES \
( %d, \"%s\", %d);\n", $1, $2, $3}' >>  patch_0.0.2.cmd

#################

git diff -U0 --output=release/artist_countries_0.0.2 0.0.1 0.0.2 db/origin_artist_countries.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/artist_countries_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "DELETE FROM artist_countries WHERE sn = %d;\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/artist_countries_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "INSERT INTO artist_countries \
(sn, name, priority) VALUES \
( %d, \"%s\", %d);\n", $1, $2, $3}' >>  patch_0.0.2.cmd

##############

echo "UPDATE versions SET major = 0, minor = 0, patch = 2 WHERE name = 'song';">> patch_0.0.2.cmd
echo "VACUUM;" >> patch_0.0.2.cmd



