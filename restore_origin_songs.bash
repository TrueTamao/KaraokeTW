#!/bin/bash

sudo su postgres -c "dropdb --if-exists origin_songs"
sudo su postgres -c "createdb origin_songs"
sudo su postgres -c "psql origin_songs < ./db/song.dump"
