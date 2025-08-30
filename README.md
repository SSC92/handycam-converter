# handycam-converter
Converts video from old SONY handycams to MPV

## Shell Script Description

The file `convert.sh` is a Bash script included in this repository. Its main purpose is to automate the conversion of videos recorded with SONY Handycam devices to the MPV format.

**Key features of the script:**
- Batch processes video files from a specified directory.
- Uses tools such as `ffmpeg` for format conversion.
- Allows customization of parameters like quality, resolution, and codecs.
- Displays informative messages to help you track the conversion progress.

**Basic usage:**
```bash
./convert.sh [video_directory]
```
This will convert all videos found in the specified directory to the MPV format.
