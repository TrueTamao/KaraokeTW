#!/bin/bash

sudo su postgres -c "vacuumdb -f origin_songs"
sudo su postgres -c "pg_dump -d origin_songs  -t youtube_videos -O -f ~/youtube.dump"
cp -f /var/lib/postgresql/youtube.dump db
