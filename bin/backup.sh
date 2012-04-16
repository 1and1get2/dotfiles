#!/bin/sh

# IMPORTANT: Make sure you update the `DST` variable to
# match the name of the destination backup drive

PROG=$0
RSYNC="/usr/bin/rsync"
SRC="/"
DST="/Volumes/Macintosh HD/"
EXCLUDE="$HOME/.dotfiles/bin/backup_excludes.txt"

# -v increase verbosity
# -a turns on archive mode (recursive copy + retain attributes)
# -x don't cross device boundaries (ignore mounted volumes)
# -E preserve executability
# -S handle spare files efficiently
# --delete deletes any files that have been deleted locally
# --exclude-from reference a list of files to exclude
# --delete-excluded

if [ ! -r "$SRC" ]; then
 /usr/bin/logger -t $PROG "Source $SRC not readable - Cannot start the sync process"
 exit;
fi

if [ ! -w "$DST" ]; then
 /usr/bin/logger -t $PROG "Destination $DST not writeable - Cannot start the sync process"
 exit;
fi

/usr/bin/logger -t $PROG "Start rsync"

sudo $RSYNC -vaxE -S --delete --exclude-from=$EXCLUDE "$SRC" "$DST"

/usr/bin/logger -t $PROG "End rsync"

# make the backup bootable - comment this out if needed
sudo bless -folder "$DST"/System/Library/CoreServices

exit 0
