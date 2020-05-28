#!/bin/bash

dbname=postgresql://mapa:mapacode@localhost:5432/origin_songs

sudo su postgres -c "dropdb --if-exists origin_songs"
sudo su postgres -c "createdb origin_songs"
sudo su postgres -c "psql origin_songs < ./db/song.dump"

# 已刪除的歌手，對應的歌曲也應該是已刪除的狀態
psql -d ${dbname} -c "
    UPDATE songs
    SET deleted = true
    FROM artists
    WHERE songs.artist = artists.sn AND artists.deleted = TRUE;"

# 產生 songs csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT songs.sn,
       songs.name,
       UPPER(regexp_replace(songs.name, '[^a-zA-Z0-9]+', '','g')) as fuzzy_name,
       array_length(regexp_split_to_array(trim(songs.name), '\s+'), 1),
       path,
       kjbcode,
       songs.language,
       songs.category,
       songs.artist as artist_sn,
       artists.name as artist_name,
       UPPER(regexp_replace(artists.name, '[^a-zA-Z0-9]+', '','g')) as artist_fuzzy_name,
       loudness,
       vocal
       from songs JOIN artists on songs.artist = artists.sn
       WHERE songs.deleted = FALSE
       ORDER BY sn )
       TO STDOUT with DELIMITER '|' csv ;" > ./db/songs.csv

# 產生 karol 的 artists csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT sn,
       name,
       UPPER(regexp_replace(name, '[^a-zA-Z0-9]+', '','g')) as fuzzy_name,
       array_length(regexp_split_to_array(trim(name), '\s+'), 1),
       category,
       country,
       picture
       FROM artists
       WHERE deleted = FALSE
       ORDER BY sn )
       TO STDOUT with DELIMITER '|' csv ;" > ./db/artists.csv

# 產生原始的 song_categories csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT sn, name, priority from song_categories WHERE deleted = FALSE ORDER BY sn )
    TO STDOUT with DELIMITER '|' csv ;" > ./db/song_categories.csv

# 產生原始的 song_languages csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT sn, name, priority from song_languages WHERE deleted = FALSE ORDER BY sn )
    TO STDOUT with DELIMITER '|' csv ;" > ./db/song_languages.csv

# 產生原始的 artist_categories csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT sn, name, priority from artist_categories WHERE deleted = FALSE ORDER BY sn )
    TO STDOUT with DELIMITER '|' csv ;" > ./db/artist_categories.csv

# 產生原始的 artist_countries csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT sn, name, priority from artist_countries WHERE deleted = FALSE ORDER BY sn )
    TO STDOUT with DELIMITER '|' csv ;" > ./db/artist_countries.csv
