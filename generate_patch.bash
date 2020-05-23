#!/bin/bash

patch=./release/patch.db

rm -rf ${patch}
sqlite3 -line ${patch} < db/patch_schemas.sql

git diff -U0 --output=release/patch_0.0.2 0.0.1 0.0.2 db/origin_songs.csv 

grep -e ^-[1-9] release/patch_0.0.2  

