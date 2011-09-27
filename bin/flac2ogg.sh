#!/bin/bash
# Simple script to recursively convert a directory of flac files to ogg.
# It is advised to fix tags with MusicBrainz Picard afterwise.
#
# Updates: https://github.com/lidel/dotfiles/blob/master/bin/flac2ogg.sh
# License: CC0 (public domain)

test -z "$*" && echo "usage: $0 source/dir destination/dir" && exit 0

find "$1" -name *.flac -print0 | while read -d $'\0' IF
do
  OF=`echo "$IF" | sed s/\.flac$/.ogg/g | sed s,"$1","$2",g`
  echo "$IF" "->" "$OF"
  mkdir -p "${OF%/*}"

  ARTIST=`metaflac "$IF" --show-tag=ARTIST | sed s/.*=//g`
  TITLE=`metaflac "$IF" --show-tag=TITLE | sed s/.*=//g`
  ALBUM=`metaflac "$IF" --show-tag=ALBUM | sed s/.*=//g`
  GENRE=`metaflac "$IF" --show-tag=GENRE | sed s/.*=//g`
  TRACKNUMBER=`metaflac "$IF" --show-tag=TRACKNUMBER | sed s/.*=//g`
  DATE=`metaflac "$IF" --show-tag=DATE | sed s/.*=//g`

  nice flac -c -d "$IF" 2> /dev/null | nice oggenc -Q -q 8 -d "$DATE" -N "${TRACKNUMBER:-0}" -t "$TITLE" -l "$ALBUM" -G "${GENRE:-12}" -a "$ARTIST" - > "$OF"
done

