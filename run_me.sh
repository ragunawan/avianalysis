#!/bin/bash

### this code is to be executed to insert scripts into crontab

## sample
# (crontab -l 2>/dev/null; echo "*/5 * * * * /path/to/job -with args") | crontab -

## sound script insertion upon checking crontab to see if they exist

#if [$(crontab -l)  | grep "sound3.sh" != ]
(crontab -l 2>/dev/null; echo "01 16 * * * /home/pi/sound3.sh") | crontab -
(crontab -l 2>/dev/null; echo "05 00 * * * /usr/local/bin/sunwait sun up -0:15:00 28.3943N 80.7473W") | crontab -