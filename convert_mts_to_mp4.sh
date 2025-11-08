#!/bin/bash

# Script to convert .MTS files to .MP4 using ffmpeg
# Usage:
#   ./convert_mts_to_mp4.sh [MTS file] [destination path]
#   ./convert_mts_to_mp4.sh -all [MTS directory] [destination directory]

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
  local SRC_DIR="$1"
  local DEST_DIR="$2"
  
  if [ ! -d "$SRC_DIR" ]; then
    echo "Source directory does not exist: $SRC_DIR"
    exit 2
  fi
  
  if [ ! -d "$DEST_DIR" ]; then
    echo "Creating destination directory: $DEST_DIR"
    mkdir -p "$DEST_DIR"
    if [ $? -ne 0 ]; then
      echo "Failed to create destination directory: $DEST_DIR"
      exit 3
    fi
  fi

  echo "Scanning for .MTS files in $SRC_DIR ..."
  shopt -s nullglob
  for f in "$SRC_DIR"/*.MTS "$SRC_DIR"/*.mts; do
    # Get the creation/modification date of the file
    # Linux/macOS compatibility: different stat invocations and date formatting
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
  if [ $# -ne 3 ]; then
    echo "Usage: $0 -all [MTS directory] [destination directory]"
    exit 1
  fi
  convert_all "$2" "$3"
else
  if [ $# -lt 2 ]; then
    echo "Usage: $0 filename.mts /path/to/output.mp4"
    exit 1
  fi
  convert_single "$1" "$2"
fi
