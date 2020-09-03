#!/bin/bash

### This code is to test some command line arguments on macOS to ensure they'll run properly on Raspbian.

FILENAME=$(date +"%Y%m%d_%H%M")
LOG="$FILENAME.log"
#begin log
touch $LOG
echo $FILENAME >> $LOG
echo "[status] test1" >> $LOG
echo "[status] test2" >> $LOG