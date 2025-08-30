# handycam-converter
Converts video from old SONY handycams to MP4 format

## Usage

The `convert_mts_to_mp4.sh` script converts .MTS files to .MP4 using ffmpeg:

```bash
./convert_mts_to_mp4.sh filename.mts /path/to/output.mp4
```

### Requirements

- ffmpeg must be installed on your system
- The script assumes you run it in the same directory as the .MTS file

### Features

- Validates input arguments
- Checks for file existence
- Outputs conversion progress
- Provides instructions for playback with mpv
