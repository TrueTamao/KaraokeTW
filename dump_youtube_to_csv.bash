#!/bin/bash

dbname=postgresql://mapa:mapacode@localhost:5432/origin_songs

psql -d ${dbname} -c "
    COPY
    (SELECT * FROM youtube_videos ORDER BY id )
       TO STDOUT with DELIMITER ',' csv ;" > ./db/youtube_videos.csv
