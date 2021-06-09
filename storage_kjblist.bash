#!/bin/bash
dbname=postgresql://mapa:mapacode@localhost:5432/origin_songs

#psql -d ${dbname} -c "UPDATE songs SET new_file = FALSE WHERE sn <= 84701;"

# 產生 kjblist 檔
psql -d ${dbname} -c "
    COPY
    (SELECT kjbcode from songs where new_file = TRUE ORDER BY songs.sn )
       TO STDOUT with DELIMITER ',' csv header;" > ./kjblist.csv

#inserts=$(grep -c ./kjblist.csv)

grep -e ^[1-9] ./kjblist.csv | awk -F"|" '{printf "gsutil -m cp -r gs://new_songs/new_song_videos_44100_25fps/%s gs://song_videos_standard/indonesia_video_out_44100_25fps/\n",$1}'
grep -e ^[1-9] ./kjblist.csv | awk -F"|" '{printf "gsutil mv gs://song_videos_standard/indonesia_video_out_44100_25fps/%s/%s_unenc.m3u8 gs://song_videos_standard/indonesia_video_out_44100_25fps/%s/%s.m3u8\n",$1,$1,$1,$1}'