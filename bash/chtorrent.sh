#!/bin/bash
#
# Author: Letheed <letheed@outlook.com>
#
# Make sure that the directories I create in the torrent directory belong to debian-transmission.
# I create them with root access to keep that video collection tidy, for access through samba share.
# Ownership must be changed before transmission moves the files from the download folder to their
# rightfull location upon download completion.
#
# I added a little more than I wanted to at first.
# That's in case I download or move anything to this directory, like subtitles.
# The right umask is set in transmission-daemon (0022),
# but just in case, ownerships and permissions are always covered.
#
####################################################################################################

TORRENT_DIR="/srv/torrent/Terminés/"

inotifywait --monitor --recursive --event create,moved_to --format '%w%f' "$TORRENT_DIR" | while read NEW_FILE; do
	if [ -d "$NEW_FILE" ]; then
		chown debian-transmission:debian-transmission -R "$NEW_FILE"
		find "$NEW_FILE" -type d -print0 | xargs -0 -r chmod 755
		find "$NEW_FILE" -type f -print0 | xargs -0 -r chmod 644
	elif [ -f "$NEW_FILE" ]; then
		chown debian-transmission:debian-transmission "$NEW_FILE"
		chmod 644 "$NEW_FILE"
	fi
done

exit 0
