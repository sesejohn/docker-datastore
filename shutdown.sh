#!/bin/bash

#####################################################
#####################################################
# HOW TO USE
# 
# $ ./shutdown.sh
# 
#####################################################
#####################################################
# Reset
RESET='\033[0m';           # Text Reset
# Regular Colors
BLACK='\033[0;30m';        # Black
RED='\033[0;31m';          # Red
GREEN='\033[0;32m';        # Green
YELLOW='\033[0;33m';       # Yellow
BLUE='\033[0;34m';         # Blue
PURPLE='\033[0;35m';       # Purple
WHITE='\033[0;37m';        # White

# stops and removes datastore containers
__shutdown_datastore() {
    subdirectories=*/;
    echo -e "${BLUE}Shutting config datastores ..........${RESET}";
    for subdirectory in $subdirectories
    do
        cd "$subdirectory" && docker-compose down && cd ..;
    done
}

__shutdown_datastore;