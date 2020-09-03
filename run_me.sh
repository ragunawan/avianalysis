#!/bin/bash

### This code is to be executed to insert scripts into the user profile's crontab

## sample
# (crontab -l 2>/dev/null; echo "*/5 * * * * /path/to/job -with args") | crontab -

## sound script insertion upon checking crontab to see if they exist

## still need to fix logic to do automatic detection if contents of crontab already contain entries for these scripts
#if [$(crontab -l)  | grep "sound3.sh" != ]

# crontab insertion for sound.sh script
(crontab -l 2>/dev/null; echo "01 16 * * * /home/pi/sound4.sh") | crontab -

# crontab insertion for sunwait program execution - [CURRENTLY IN CRON]
#(crontab -l 2>/dev/null; echo "05 00 * * * /usr/local/bin/sunwait sun up -0:15:00 28.3943N 80.7473W") | crontab -