#!/bin/bash
shopt -s -o nounset
i=0
kjbstart=$1
kjbend=$2
logfile=no_uenc_$kjbstart-$kjbend.txt

echo "Start check for unenc not found from " $kjbstart " to " $kjbend > $logfile

for ((i=$kjbstart; i<= $kjbend; i=i+1))
do
  #echo "current code: " + $i
  #printf "gsutil -m cp591732 -r gs://new_songs/new_song_videos_44100_25fps/%s gs://song_videos_standard/indonesia_video_out_44100_25fps/ \n" $kjbcode >> cp_to_storage.bash

  kjbcode=$i
  m3u8_file=gs://song_videos_standard/indonesia_video_out_44100_25fps/$kjbcode/$kjbcode.m3u8
  gsutil -q stat $m3u8_file
  m3u8_status=$?
  
  if (($m3u8_status == 0)); then

    for video_path in videoHlsLd
    do
      file_path=gs://song_videos_standard/indonesia_video_out_44100_25fps/$kjbcode/$video_path/video_unenc.m3u8
      #echo "filepath: " + $file_path
      gsutil -q stat $file_path
      status=$?

      if (($status != 0)); then
        echo $kjbcode $video_path "  Unenc File does not exist status " $status >> $logfile
      fi
    done
  fi
done

