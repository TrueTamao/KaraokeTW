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
       array_length(regexp_split_to_array(trim(regexp_replace(songs.name, '\(.*\)', '','g')), '\s+'), 1),
       path,
       kjbcode,
       songs.language,
       songs.category,
       songs.artist,
       loudness,
       vocal
       from songs JOIN artists on songs.artist = artists.sn
       JOIN song_languages ON songs.language = song_languages.sn
       WHERE songs.deleted = FALSE AND songs.sn > 0
       ORDER BY songs.sn )
       TO STDOUT with DELIMITER '|' csv ;" > ./db/songs.csv

psql -d ${dbname} -c "COPY (SELECT * from songs ORDER BY sn) TO STDOUT with DELIMITER '|' csv ;" > ./db/origin_songs.csv

# 產生 karol 的 artists csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT artists.sn,
       artists.name,
       UPPER(regexp_replace(artists.name, '[^a-zA-Z0-9]+', '','g')) as fuzzy_name,
       array_length(regexp_split_to_array(trim(regexp_replace(artists.name, '\(.*\)', '','g')), '\s+'), 1),
       category,
       country,
       picture
       FROM artists JOIN artist_countries ON artists.country = artist_countries.sn
       WHERE artists.deleted = FALSE and artists.sn > 0
       ORDER BY artists.sn )
       TO STDOUT with DELIMITER '|' csv ;" > ./db/artists.csv

psql -d ${dbname} -c "COPY (SELECT * from artists ORDER BY sn) TO STDOUT with DELIMITER '|' csv ;" > ./db/origin_artists.csv

# 產生原始的 song_categories csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT sn, name, priority from song_categories WHERE deleted = FALSE ORDER BY sn )
    TO STDOUT with DELIMITER '|' csv ;" > ./db/song_categories.csv

# 產生原始的 song_languages csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT sn, name, priority from song_languages WHERE deleted = FALSE AND name <> 'YouTube' ORDER BY sn )
    TO STDOUT with DELIMITER '|' csv ;" > ./db/song_languages.csv

# 產生原始的 artist_categories csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT sn, name, priority from artist_categories WHERE deleted = FALSE AND name <> 'YouTuber' ORDER BY sn )
    TO STDOUT with DELIMITER '|' csv ;" > ./db/artist_categories.csv

# 產生原始的 artist_countries csv 檔
psql -d ${dbname} -c "
    COPY
    (SELECT sn, name, priority from artist_countries WHERE deleted = FALSE ORDER BY sn )
    TO STDOUT with DELIMITER '|' csv ;" > ./db/artist_countries.csv
