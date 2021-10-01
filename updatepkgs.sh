#!/usr/bin/env bash

# Start Runtime Counter
STRT=$(date +%s)

# Get System Architecture
# Arch="x86_64"
ARCH=$(uname -m)

# Temperory Directory
DIR="./tmp"

# Packages URLs List
FILE="./list.txt"

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

# Remove Existing Package Files
if [[ -e $DIR ]]; then
    echo -en "${PINK}# Sorry, But \"$DIR\" Currently Exists, Will You Remove It? [y/N] ${RESET}"
    read ASK
    case "${ASK}" in
        [Yy][Ee][Ss]|Y|y)
            rm -rf $DIR
            echo -e "${RED}# Current \"$DIR\" Folder Deleted.${RESET}"
            STRT=$(date +%s)
        ;;
        *)
            echo -e "${RED}# You Need To Delete \"$DIR\" Before Starting.${RESET}"
            exit
	;;
    esac
fi

# Create Package Directory
mkdir -p $DIR
cp $FILE $DIR

# Get Into Package Directory
cd $DIR

# Announce Cloning Process
echo -e "${CYAN}# Cloning Repositories to Local...${RESET}"

# Looping Into Lines
GITCOUNT=0; while read LINE; do

    # Return Cloning Message
    echo -e "${YELLOW}# Cloning \"$LINE\"...${RESET}"

    # Cloning Package to $DIR
    git clone -q $LINE

    # Increase Counter
    ((GITCOUNT++))

done < $FILE

# Fix Sub Directories (Only for rostam-misc-pkgs)
mv rostam-packages/*/ .
rm -rf rostam-packages

# Return Success Message
echo -e "${BLUE}# Cloned $GITCOUNT Repositories Successfully.${RESET}"

# Back to User's Path
cd $WORKING_DIR

# List Package Directories
DIRS=($DIR/*/)

# Checking Updates Message
echo -e "${CYAN}# Checking for Updates...${RESET}"

# Set Updated Packages Counter
UPDATEDPKGS=0

# Looping Into * Directories
for PKGDIR in "${DIRS[@]}"; do

    # Get Into PKG Folder
    cd $PKGDIR

    # Package's Name
    PKG=$(basename $PKGDIR)

    # Get Old Build Version
    OLDBUILD=$(ls $WORKING_DIR/$ARCH/$PKG-*.pkg.tar.zst 2> /dev/null)
    OLDBUILD=$(basename $OLDBUILD 2> /dev/null)
    OLDBUILDN=${OLDBUILD/$PKG/}
    OLDPKGVER=$(awk -F- '{print $2}' <(echo $OLDBUILDN))
    OLDPKGREL=$(awk -F- '{print $3}' <(echo $OLDBUILDN))
    if ! [[ "$OLDPKGREL" =~ ^[0-9]+$ ]]; then
        OLDBUILDVER="$OLDPKGVER"
    else
        OLDBUILDVER="$OLDPKGVER-$OLDPKGREL"
    fi

    # Set Old Version For New Packages
    if [[ ! $OLDBUILDVER ]]; then
        OLDBUILDVER="0"
    fi

    # Get Current Build Version
    source ./PKGBUILD
    if [[ $epoch ]]; then
        prefix="$epoch:"
    fi
    if [[ $pkgrel ]]; then
        postfix="-$pkgrel"
    fi
    NEWBUILDVER="$prefix$pkgver$postfix"

    # If There Was a Newer Version:
    if [[ $NEWBUILDVER != $OLDBUILDVER ]]; then

        # Return Message
        echo -e "${YELLOW}# Update for $PKG Available, Starting Build...${RESET}"

        # Build Package
        makepkg -s &> /dev/null

        # Get Current Build Name
        NEWBUILD=$(ls *.pkg.tar.zst)

        # Remove Old Build
        rm $WORKING_DIR/$ARCH/$OLDBUILD

        # Copy New Build to Package Repository
        cp $NEWBUILD $WORKING_DIR/$ARCH

        # Return Success Message
        echo -e "${BLUE}# $PKG's Package updated from $OLDBUILDVER to $NEWBUILDVER Successfully.${RESET}"

        # Update Counter
        ((UPDATEDPKGS++))
    
    else
        # Return Message
        echo -e "${CYAN}# $PKG $NEWBUILDVER is Up-To-Date.${RESET}"
    fi

    # Unset PKGBUILD and Loop's Variables
    unset prefix postfix pkgname pkgver pkgrel epoch OLDBUILDVER NEWBUILDVER

    # Back to User's Path
    cd $WORKING_DIR

done

# Return Success Message
echo -e "${BLUE}# Updated $UPDATEDPKGS of $GITCOUNT Packages Successfully.${RESET}"

# Remove Temperory Directory
rm -rf $DIR
echo -e "${BLUE}# Deleted Temperory \"$DIR\" Directory Successfully.${RESET}"

# End Runtime Counter
ENDT=$(( $(date +%s) - $STRT ))

# Return Success Message
echo -e "${GREEN}# Done! It took $ENDT Seconds to Build Packages Successfully.${RESET}"
