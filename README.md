<h1 align="center">
  <img src="https://raw.githubusercontent.com/MahdyMirzade/MahdyMirzade/main/assets/gifs/gear.gif" width="30px"/>
  RostamPkgs
</h1>
<h3 align="center">All necessary compiled packages for me and my projects in one repository.</h3>

### <img src="https://raw.githubusercontent.com/MahdyMirzade/MahdyMirzade/main/assets/icons/emotes/plus.png" width="16px"/> Add Rostam Repository to Arch Linux

Add these lines to the end of `/etc/pacman.conf`:
```
[rostam]
SigLevel = Optional TrustAll
Server = https://rostamlinux.github.io/RostamPkgs/$arch
```
Then update database files with executing this command:
```
$ pacman -Syy
```


### <img src="https://raw.githubusercontent.com/MahdyMirzade/MahdyMirzade/main/assets/icons/emotes/minus.png" width="16px"/> Remove Rostam Repository

Comment out `[rostam]` profile in `/etc/pacman.conf`, It should be like:
```
# [rostam]
# SigLevel = Optional TrustAll
# Server = https://rostamlinux.github.io/RostamPkgs/$arch
```
Then update database files with executing this command:
```
$ pacman -Syy
```

### <img src="https://raw.githubusercontent.com/MahdyMirzade/MahdyMirzade/main/assets/icons/emotes/pickaxe.png" width="16px"/> Understaing the Process of Updating Repository

**Details:** This repository is based on the compiled packages in my personal computer from official [aur.archlinux.org](https://aur.archlinux.org).

**Automotion:** To Update Database + Packages, I'll run `./update.sh` every day, this script includes `./updatepkgs.sh` and `./updatedb.sh`.

**For new .pkg.tar.zst:** I add `*.pkg.tar.zst` files to `x86_64` or any other system architecture, Then I'll run `./updatedb.sh` to add it to Repository's Database.

**For new packages:** I add *AUR Package's Name* to the end of `list.txt` file, then I'll run `./updatepkgs.sh` to add its archive, then I'll update the database by running `./updatedb.sh`.

**Once an AUR package is updated:** I execute `./updatepkgs.sh` to update package archive, then I'll run `./updatedb.sh` to Update Repository's Database.
