#!/bin/bash

# Script to convert .MTS files to .MP4 using ffmpeg
# Usage: ./convert_mts_to_mp4.sh [MTS file] [destination path]

# Check arguments
if [ $# -lt 2 ]; then
  echo "Usage: $0 filename.mts /path/to/output.mp4"
  exit 1
fi

FILENAME="$1"
DEST_PATH="$2"

if [ ! -f "$FILENAME" ]; then
  echo "File not found: $FILENAME"
  exit 2
fi

echo "Converting $FILENAME to $DEST_PATH ..."
ffmpeg -i "$FILENAME" -c:v copy -c:a aac -b:a 192k "$DEST_PATH"

echo "Conversion complete. Ready to play with mpv:"
echo "mpv \"$DEST_PATH\""
