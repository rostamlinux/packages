#!/usr/bin/env bash

# Performing Package Rebuild + Database Update For Automotion Purposes.

# Start Runtime Counter
STRT=$(date +%s)

# Colors
WHITE="\e[0;97m"
CYAN="\e[0;96m"
PINK="\e[0;95m"
BLUE="\e[0;94m"
YELLOW="\e[0;93m"
GREEN="\e[0;92m"
RED="\e[0;91m"
RESET="\e[0m"

# Check For Package Updates
bash updatepkgs.sh

# Update Repository Database
bash updatedb.sh

# Push changes to repository
MSG="$(date +'%d %B %Y') - Repository Updated."
echo -e "${CYAN}# Pushing changes...${RESET}"
git commit -a -m "Update" > /dev/null
git rm -r --cached x86_64 > /dev/null
git commit -m "Performing Clean Up..." > /dev/null
git add -A . > /dev/null
git commit -m "$MSG" > /dev/null
git branch -m main > /dev/null
git push origin --force > /dev/null
echo -e "${BLUE}# $MSG${RESET}"

echo -e "${GREEN}# Clean up completed.${RESET}"
