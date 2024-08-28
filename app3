#!/usr/bin/bash

# If no arguments are provided, set REQUEST to an empty string
if [ $# -eq 0 ]; then
  REQUEST=""
else
  # Join all arguments into a single string
  REQUEST="$1"
fi

# Pass the entire REQUEST as one argument
python3 src/app.py "$REQUEST"
