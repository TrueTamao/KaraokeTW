#!/bin/bash
shopt -s -o nounset

kjbcode_list=$(cat kjbcode_new.txt)
kjbcodes=''

for kjbcode in $kjbcode_list
do
  #echo " code: " $kjbcode
  kjbcodes=$kjbcodes" '"$kjbcode"',"
done
kjbcodes=$(echo "${kjbcodes::-1}")
#echo " kjbcodes: " + $kjbcodes
sql="psql -d origin_songs -t -A -F\",\" -c \"select songs.sn, kjbcode, songs.name, artists.name from songs, artists where songs.artist = artists.sn and kjbcode in ("$kjbcodes")order by kjbcode\" > test.csv"
echo "sql: " $sql
