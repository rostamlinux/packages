#!/usr/bin/env bash

# Start Runtime Counter
STRT=$(date +%s)

# Current Working Directory
WORKING_DIR=${PWD}

# Colors
WHITE="\e[0;97m"
CYAN="\e[0;96m"
PINK="\e[0;95m"
BLUE="\e[0;94m"
YELLOW="\e[0;93m"
GREEN="\e[0;92m"
RED="\e[0;91m"
RESET="\e[0m"

# List Directories
DIRS=(*/)

# Looping Into * Directories
for DIR in $DIRS; do

    # Ignore "./aur"
    if [[ $DIR == "aur/" ]]; then
        continue
    fi

    # Get Into $arch Directory
    cd $DIR
    
    # Remove Existing Repository Database
    echo -e "${RED}# Deleting Existing \"$DIR\" Database...${RESET}"
    rm -f rostam.*
    sleep 1

    # Creating/Updating Repository Database
    echo -e "${YELLOW}# Updating \"$DIR\" Repository Database...${RESET}"
    repo-add rostam.db.tar.gz *.pkg.tar.zst > /dev/null
    sleep 1

    # Return Success Message
    echo -e "${BLUE}# \"$DIR\" Repository Database is Updated...${RESET}"

    # Return to Old Path
    cd $WORKING_DIR

done

# End Runtime Counter
ENDT=$(( $(date +%s) - $STRT ))

# Return Success Message
echo -e "${GREEN}# Done! It took $ENDT Seconds to Update Repository Databases.${RESET}"
