#!/bin/bash
shopt -s -o nounset
i=0
kjbstart=10001
kjbend=591732

echo "Start check for unenc not found from " $kjbstart " to " $kjbend > no_unenc.txt

for ((i=$kjbstart; i<= $kjbend; i=i+1))
do
  #echo "current code: " + $i
  kjbcode=$i
  printf "gsutil -m cp591732 -r gs://new_songs/new_song_videos_44100_25fps/%s gs://song_videos_standard/indonesia_video_out_44100_25fps/ \n" $kjbcode >> cp_to_storage.bash

  for video_path in videoHlsLd
  do
    file_path=gs://song_videos_standard/indonesia_video_out_44100_25fps/$kjbcode/$video_path/video_unenc.m3u8
    echo "filepath: " + $file_path
    gsutil -q stat $file_path
    status=$?

    if (($status != 0)); then
      echo $kjbcode $video_path "  Unenc File does not exist status " $status >> no_unenc.txt
    fi
  done
done

