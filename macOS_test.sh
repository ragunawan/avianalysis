#!/bin/bash

### This code is to test and debug commands on macOS to ensure they'll run properly on Raspbian.
## Ignore - not meant for use in production.

FILENAME=$(date +"%Y%m%d_%H%M")
LOG="$FILENAME.log"

#begin log
touch $LOG
echo $FILENAME >> $LOG
echo "[status] test1" >> $LOG
echo "[status] test2" >> $LOG