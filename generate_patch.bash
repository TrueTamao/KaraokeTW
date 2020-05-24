#!/bin/bash

patch=./release/patch.db

rm -rf ${patch}
sqlite3 -line ${patch} < db/patch_schemas.sql

git diff -U0 --output=release/patch_0.0.2 0.0.1 0.0.2 db/origin_songs.csv 


#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "INSERT INTO songs (sn, deleted) VALUES ( %d, 1);\n", $1}' > patch_0.0.2.cmd

grep -e ^+[1-9] release/patch_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "REPLACE INTO songs \
(sn, name, fuzzy_name, word_count, kjbcode, language, category, artist_sn, artist_name, artist_fuzzy_name, loudness, vocal_channel, deleted) VALUES \
( %d, \"%s\", \"%s\", %d, \"%s\", %d, %d, %d, \"%s\", \"%s\", %d, %d, %d);\n", $1, $2, $3, $4, $6, $7, $8, $9, $10, $11, $12, $13, $14}' >>  patch_0.0.2.cmd

#################

git diff -U0 --output=release/artists_0.0.2 0.0.1 0.0.2 db/origin_artists.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/artists_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "INSERT INTO artists (sn, deleted) VALUES ( %d, 1);\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/artists_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "REPLACE INTO artists \
(sn, name, fuzzy_name, word_count, category, country, deleted) VALUES \
( %d, \"%s\", \"%s\", %d, %d, %d, %d);\n", $1, $2, $3, $4, $5, $6, $8}' >>  patch_0.0.2.cmd

#################

git diff -U0 --output=release/song_categories_0.0.2 0.0.1 0.0.2 db/origin_song_categories.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/song_categories_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "INSERT INTO song_categories (sn, deleted) VALUES ( %d, 1);\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/song_categories_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "REPLACE INTO song_categories \
(sn, name, priority, deleted) VALUES \
( %d, \"%s\", %d, 0);\n", $1, $2, $3}' >>  patch_0.0.2.cmd

###############

git diff -U0 --output=release/song_languages_0.0.2 0.0.1 0.0.2 db/origin_song_languages.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/song_languages_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "INSERT INTO song_languages (sn, deleted) VALUES ( %d, 1);\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/song_languages_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "REPLACE INTO song_languages \
(sn, name, priority, deleted) VALUES \
( %d, \"%s\", %d, 0);\n", $1, $2, $3}' >>  patch_0.0.2.cmd

#################

git diff -U0 --output=release/artist_categories_0.0.2 0.0.1 0.0.2 db/origin_artist_categories.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/artist_categories_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "INSERT INTO artist_categories (sn, deleted) VALUES ( %d, 1);\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/artist_categories_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "REPLACE INTO artist_categories \
(sn, name, priority, deleted) VALUES \
( %d, \"%s\", %d, 0);\n", $1, $2, $3}' >>  patch_0.0.2.cmd

#################

git diff -U0 --output=release/artist_countries_0.0.2 0.0.1 0.0.2 db/origin_artist_countries.csv 

#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'

grep -e ^-[1-9] release/artist_countries_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "INSERT INTO artist_countries (sn, deleted) VALUES ( %d, 1);\n", $1}' >> patch_0.0.2.cmd

grep -e ^+[1-9] release/artist_countries_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "REPLACE INTO artist_countries \
(sn, name, priority, deleted) VALUES \
( %d, \"%s\", %d, 0);\n", $1, $2, $3}' >>  patch_0.0.2.cmd

##############

echo "INSERT INTO versions (name, major, minor, patch) VALUES ('song', 0, 0, 2);">> patch_0.0.2.cmd
echo "VACUUM;" >> patch_0.0.2.cmd

sqlite3 -line ${patch} < patch_0.0.2.cmd


