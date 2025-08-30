#!/bin/bash

# Script to convert .MTS files to .MP4 using ffmpeg
# Usage:
#   ./convert_mts_to_mp4.sh [MTS file] [destination path]
#   ./convert_mts_to_mp4.sh -all [destination directory]

convert_single() {
  local FILENAME="$1"
  local DEST_PATH="$2"

  if [ ! -f "$FILENAME" ]; then
    echo "File not found: $FILENAME"
    return 2
  fi

  echo "Converting $FILENAME to $DEST_PATH ..."
  ffmpeg -i "$FILENAME" -c:v copy -c:a aac -b:a 192k "$DEST_PATH"

  echo "Conversion complete. Ready to play with mpv:"
  echo "mpv \"$DEST_PATH\""
}

convert_all() {
  local DEST_DIR="$1"
  if [ ! -d "$DEST_DIR" ]; then
    echo "Destination directory does not exist: $DEST_DIR"
    exit 3
  fi

  echo "Scanning for .MTS files in $(pwd) ..."
  shopt -s nullglob
  for f in *.MTS *.mts; do
    # Get the creation/modification date of the file
    # Use stat; if on macOS, you may need to adjust stat options
    if date_str=$(stat --format='%y' "$f" 2>/dev/null); then
      # Linux stat: %y = "YYYY-MM-DD HH:MM:SS.xxxxxx"
      dt=$(echo "$date_str" | awk '{print $1" "$2}')
      # Format date to dd-mm-yy-hhhh
      formatted_date=$(date -d "$dt" '+%d-%m-%y-%H%M')
    else
      # macOS stat fallback
      date_str=$(stat -f '%Sm' -t '%d-%m-%y-%H%M' "$f" 2>/dev/null)
      formatted_date="$date_str"
    fi

    out_file="$DEST_DIR/$formatted_date.mp4"
    echo "Converting $f -> $out_file"
    ffmpeg -i "$f" -c:v copy -c:a aac -b:a 192k "$out_file"
  done
  echo "All conversions complete."
}

# Main logic
if [ "$1" == "-all" ]; then
  if [ $# -ne 2 ]; then
    echo "Usage: $0 -all /path/to/output_directory"
    exit 1
  fi
  convert_all "$2"
else
  if [ $# -lt 2 ]; then
    echo "Usage: $0 filename.mts /path/to/output.mp4"
    exit 1
  fi
  convert_single "$1" "$2"
fi
