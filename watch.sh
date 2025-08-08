#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <make-target>"
    exit 1
fi

TARGET="$1"
DIR="./docs/$TARGET"

if [ ! -d "$DIR" ]; then
    echo "Error: directory $DIR does not exist"
    exit 1
fi

echo "Watching $DIR for changes…"
echo "Press Ctrl-C to stop."

while inotifywait -qq -r -e modify,create,delete "$DIR"; do
    make "$TARGET"
done

