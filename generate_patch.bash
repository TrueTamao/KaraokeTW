#!/bin/bash

patch=./release/patch.db

rm -rf ${patch}
sqlite3 -line ${patch} < db/patch_schemas.sql

git diff -U0 --output=release/patch_0.0.2 0.0.1 0.0.2 db/origin_songs.csv 


#grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g'


grep -e ^-[1-9] release/patch_0.0.2 | sed 's/^-//g' | awk -F"|" '{printf "INSERT INTO songs (sn, deleted) VALUES ( %d, %d);\n", $1, $14}' > patch_0.0.2.cmd

grep -e ^+[1-9] release/patch_0.0.2 \
| sed 's/^+//g' | awk -F"|" '{printf "REPLACE INTO songs \
(sn, name, fuzzy_name, word_count, kjbcode, language, category, artist_sn, artist_name, artist_fuzzy_name, loudness, vocal_channel, deleted) VALUES \
( %d, \"%s\", \"%s\", %d, \"%s\", %d, %d, %d, \"%s\", \"%s\", %d, %d, %d);\n", $1, $2, $3, $4, $6, $7, $8, $9, $10, $11, $12, $13, $14}' >>  patch_0.0.2.cmd

