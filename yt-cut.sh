#!/bin/bash
#echo $BASH_SOURCE
if [ -z "$1" ];then
  echo "Usage: yt-cut.sh <youtube-link> [jumpcutter-args]"
  echo "Example: yt-cut.sh https://www.youtube.com/watch?v=9C_HReR_McQ --sounded-speed 1.5 --silence-speed 5.0 --frame-margin 2"
  echo "Jumpcutter.py Parameters:
  -S | --sounded-speed <float> (default: 1.0)
  -s | --silent-speed <float> (default: 5.0)
  -t | --silent-threshold <float> (default: 0.03)
  -o | --output_file <string> (default: [input_filename]_ALTERED.mp4)
  "
  exit 1
  
fi
yt_link=$1
#echo "Getting filename."
yt_filename=$(yt-dlp -f "bv+ba/b" "$yt_link" --restrict-filename --merge-output-format=mp4 --print filename)
#echo "filename is $yt_filename"
if ! [ -f "$yt_filename" ]; then
  echo "yt-dlp: $yt_link to $yt_filename"
  yt-dlp -f "bv+ba/b" "$yt_link" --restrict-filename --merge-output-format=mp4
fi
yt_filename_altered="${yt_filename%.*}_ALTERED.mp4"
if ! [ -f "$yt_filename_altered" ]; then
  shift
  echo "jumpcutter.py $yt_filename to $yt_filename_altered"
  jumpcutter.py -i "$yt_filename" $@
else
  echo "Skipping. $yt_filename_altered already exist. delete to re-cut"
fi
echo
echo
echo