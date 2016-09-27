#!/bin/bash

# Check that the user has supplied at least one argument
if (( "$#" < 1 )); then
    echo "Usage: build.sh [image].def [options]\n"
    echo "Example:\n"
    echo "       build.sh python.def --size 786"
    exit 1
fi

def=$1

# Pop off the image name
shift

# If there are more args
if [ "$#" -eq 0 ]; then
    args="--size 1024*1024B"
else
    args="$@"
fi

# Continue if the image is found
if [ -f "$def" ]; then

    # The name of the image is the definition file minus extension
    imagefile=`echo "${def%%.*}"`
    echo "Creating $imagefile using $def..."
    sudo singularity create $args $imagefile
    sudo singularity bootstrap $imagefile $def
fi
