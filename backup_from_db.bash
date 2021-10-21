#!/bin/bash

sudo -u postgres psql -d origin_songs -c "DROP TABLE IF EXISTS youtube_videos;"
sudo -u postgres psql -d origin_songs -c "DROP TABLE IF EXISTS pglogical_test_ids;"
sudo -u postgres psql -d origin_songs -c "DROP TABLE IF EXISTS pglogical_test_sns;"

sudo su postgres -c "vacuumdb -f origin_songs"
sudo su postgres -c "pg_dump -d origin_songs -O -f ~/song.dump"
cp -f /var/lib/postgresql/song.dump db
