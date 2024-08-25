#!/usr/bin/bash

# Check if the script was called with arguments
if [ "$#" -eq 0 ]; then
    # No arguments: run the main application
    python3 src/app.py
elif [ "$#" -eq 1 ]; then
    # One argument: handle requests
    REQUEST=$1
    python3 src/app.py --request "$REQUEST"
else
    echo "Usage: ./app [request]"
    exit 1
fi
