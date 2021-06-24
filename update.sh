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

# Performing a CleanUp
echo -e "${CYAN}# Performing a Repository Clean Up...${RESET}"

# Backup config & remove git dir
mv .git/config config
rm -rf .git

# Setup git 
echo -e "${CYAN}# Setting up git repository...${RESET}"
git init
git config --global user.name "mahdymirzade"
git config --global user.email "me@mahdym.ir"
git config --global init.defaultBranch "main"
git config --global credential.helper cache
git config --global credential.helper "cache --timeout=25000"
git config --global push.default simple
echo -e "${BLUE}# Git repository setup completed.${RESET}"

# Move config to git again & push changes to repository
MSG="$(date +'%d %B %Y') - Repository Updated."
echo -e "${CYAN}# Moving config to git dir & push changes...${RESET}"
mv config .git/config
git add -A .
git commit -m "$MSG"
git branch -m main
git push origin --force
echo -e "${BLUE}# $MSG${RESET}"

echo -e "${GREEN}# Clean up completed.${RESET}"
