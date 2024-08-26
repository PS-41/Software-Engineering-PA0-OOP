#!/usr/bin/python3
import argparse
from application.application import Application

def main():
    parser = argparse.ArgumentParser(description="Process the requests")
    parser.add_argument('request', nargs='*', default=[], help="Request to send to the application")
    args = parser.parse_args()

    app = Application()
    app.run(' '.join(args.request))

if __name__ == "__main__":
    main()