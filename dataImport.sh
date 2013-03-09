#!/bin/sh
sqlite3 -separator , ./db/development.sqlite3 ".import slot.csv slot"
