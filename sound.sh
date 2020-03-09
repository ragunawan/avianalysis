#!/bin/bash
FILENAME=$(date +"%Y%m%d_%H%M")

#Executed by Crontab 30min before sunrise
#Records 30 min of audio, converts to MP3, deletes .wav file, uploads to AWS, deletes WAV after sucessful upload, goes on low power mode

#usb on

#mount usb drive

#Loads audio device
Export AudioREV=hw:1,0

#Records 30 min of audio
rec -c 1 -r 44800 -b 16 /home/pi/Audio/Wav/${FILENAME}.wav bandpass 720 600 highpass 120 gain 20 trim 2 1802

#converts from .wav to .mp3
lame -b 64 ./home/pi/Audio/Wav/${FILENAME}.wav ./home/pi/Audio/upload/${FILENAME}.mp3

#deletes .wav file
rm /home/pi/Audio/wav/${FILENAME}.WAV

#moves mp3 from SD card to usb drive
mv

#cellular on

#upload to s3 (need to update file paths)
s3cmd put --reduced-redundancy --acl-public ./home/pi/Audio/upload/${FILENAME}.mp3 s3://MY_S3_BUCKET/${FILENAME}.mp3

#cellular off

#unmount usb drive

#usb off
