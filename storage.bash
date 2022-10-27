#!/bin/bash
shopt -s -o nounset
i=0
kjbcode=0
start_kjbcode=584702


echo "#!/bin/bash" > cp_to_storage.bash



for ((i=586440; i<= 587753; i=i+1))
do
    kjbcode=$i
    printf "gsutil -m cp -r gs://new_songs/new_song_videos_44100_25fps/%s gs://song_videos_standard/indonesia_video_out_44100_25fps/ \n" $kjbcode >> cp_to_storage.bash
done
