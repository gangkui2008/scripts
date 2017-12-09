#!/bin/bash
# Created by Stone on 17 Nov 2017.

#set -x

function usage {
  echo "Copy songs from source dir to target dir."
  echo "Usage: $0 <source dir> <target dir>"
  echo "Song path should be like .../artist/album/song in source directory. The structure artist/album/song will be also kept in target directory."
  echo "e.g. $0 /Users/shiyonghong/music /Users/shiyonghong/udisk/music"
  exit 1
}

if [[ $# -lt 2 ]]
then
  usage
fi

src=$1
tgt=$2

if [[ ! -d "$src" ]] || [[ ! -d "$tgt" ]]
then
  echo "$src or $tgt does not exist."
  exit 1
fi

i=1
#Only search high quality songs that < 100M.
find $src -type f -size -100M \( -name *.wav -o -name *.flac -o -name *.m4a \) | while read song
do
  songName=$(basename "$song")
  parentDir=$(dirname "$song")
  parentDirName=$(basename "$parentDir")
  gparentDir=$(dirname "$parentDir")
  gparentDirName=$(basename "$gparentDir")
  tgtSong="$tgt/$gparentDirName/$parentDirName/$songName"
  [[ -e "$tgtSong" ]] && continue
  tgtSongDir=$(dirname "$tgtSong")
  [[ ! -d "$tgtSongDir" ]] && mkdir -p "$tgtSongDir"
  echo "$i. copy $song to $tgtSong"
  cp -f "$song" "$tgtSong"
  [[ $? -ne 0 ]] && echo "Copy failed: $song" && break
  i=$((i+1))
done

echo "DONE."

exit 0


