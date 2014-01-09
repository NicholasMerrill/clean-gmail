#! /bin/sh

F_NAME="$(date +"%Y-%m-%d") report.txt"

./from-names.rb > "$F_NAME" &

echo "If you quit with Ctrl-C, you will not stop the scanning process.\n You will simply not be able to see the progress anymore."

tail -n 100 -f "$F_NAME"
