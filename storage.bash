#!/bin/bash
shopt -s -o nounset
i=0

echo "#!/bin/bash" > cp_to_storage.bash

for ((i=591649; i<= 591732; i=i+1))
do
    kjbcode=$i
    printf "gsutil -m cp -r gs://new_songs/new_song_videos_44100_25fps/%s gs://song_videos_standard/indonesia_video_out_44100_25fps/ \n" $kjbcode >> cp_to_storage.bash
done

echo -e "\e[1;5;32m Check Content of cp_to_storage.bash, And copy song files from new_songs to online storage by cp_to_storage.bash \e[0m"
