#!/bin/bash

sudo su postgres -c "vacuumdb -f origin_songs"
sudo su postgres -c "pg_dump -d origin_songs -O -f ~/song.dump"
cp -f /var/lib/postgresql/song.dump db
