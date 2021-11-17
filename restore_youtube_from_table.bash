#!/bin/bash

read -p "Source File ? " sourceFile

if [ ! -f "$sourceFile" ] ; then
    echo -e "\e[1;5;31m Invalid Source File \e[0m"
    exit 1
fi

read -p "Restore YouTube Table (Will Drop YouTube Table) (Y/N) ? [N]" restoreTable

if [ "$restoreTable" = "Y" ] || [ "$restoreTable" = "y" ] ; then

    echo -e "\e[1;5;31m Are you sure ? \e[0m"

    read -p "Mark Sure Restore YouTube (Will Drop YouTube Table) (Y/N) ? [N]" restoreMakeSure

    if [ "$restoreMakeSure" = "Y" ] || [ "$restoreMakeSure" = "y" ] ; then

        psql -d song -c "DELETE FROM youtube_videos;"
        psql song < $sourceFile
        psql -d song -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PUBLIC TO mapa;"
        psql -d song -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA PUBLIC TO mapa;"
        echo -e "\e[1;5;32m Done !! \e[0m"
    fi
fi
