#!/usr/bin/bash

# If no arguments are provided, set REQUEST to an empty string
if [ $# -eq 0 ]; then
  REQUEST=""
else
  # Store all arguments as a single request string
  REQUEST="$@"
fi

# Run the Python script with the request argument(s)
python3 src/app.py $REQUEST