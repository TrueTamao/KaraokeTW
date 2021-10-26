#!/bin/bash
shopt -s -o nounset
i=0
kjbcode=0
start_kjbcode=584702


echo "#!/bin/bash" > cp_to_storage.bash

for ((i=1; i<= 0; i=i+1))
do
    origin_kjbcode=$((i+585000))
    kjbcode=$((i+start_kjbcode))
    printf "gsutil -m cp -r gs://new_songs/new_song_videos_44100_25fps/%s gs://new_songs/new_song_videos_44100_25fps/%s \n" $origin_kjbcode $kjbcode >> cp_to_storage.bash
    printf "gsutil mv gs://new_songs/new_song_videos_44100_25fps/%s/%s.m3u8 gs://new_songs/new_song_videos_44100_25fps/%s/%s.m3u8 \n" $kjbcode $origin_kjbcode $kjbcode $kjbcode >> cp_to_storage.bash
    printf "gsutil mv gs://new_songs/new_song_videos_44100_25fps/%s/%s_unenc.m3u8 gs://new_songs/new_song_videos_44100_25fps/%s/%s_unenc.m3u8 \n" $kjbcode $origin_kjbcode $kjbcode $kjbcode >> cp_to_storage.bash
done


for ((i=585874; i<= 585903; i=i+1))
do
    kjbcode=$i
    printf "gsutil -m cp -r gs://new_songs/new_song_videos_44100_25fps/%s gs://song_videos_standard/indonesia_video_out_44100_25fps/ \n" $kjbcode >> cp_to_storage.bash
done
