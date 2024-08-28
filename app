#!/usr/bin/python3

import sys
import subprocess

if __name__ == "__main__":
    # Combine all command line arguments into a single request string
    request = ' '.join(sys.argv[1:])

    # Run the Python script with the request argument(s)
    subprocess.run(["python3", "src/app.py", request])
