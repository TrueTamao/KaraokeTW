#!/bin/bash

sudo su postgres -c "vacuumdb -f song"
sudo su postgres -c "pg_dump --data-only -d song -t youtube_videos -O -f ~/youtube.dump"
cp -f /var/lib/postgresql/youtube.dump db
