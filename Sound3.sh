#!/bin/bash
FILENAME=$(date +"%Y%m%d_%H%M")

#Executed by Crontab 30min before sunrise
#Records 30 min of audio, converts to MP3, deletes .wav file, uploads to AWS, deletes WAV after sucessful upload, goes on low power mode

#Loads audio device
sudo ./Record_from_Linein_Micbias.sh
export AUDIDEV=hw:1,0

#Records 30 min of audio
rec -c 2 -r 44800 -b 16 /home/pi/Audio/Wav/${FILENAME}.wav bandpass 720 600 highpass 120 gain 20 trim 2 32

#converts from .wav to .mp3
sudo lame -b 64 /home/pi/Audio/Wav/${FILENAME}.wav /home/pi/Audio/Upload/${FILENAME}.mp3

#deletes .wav file
sudo rm /home/pi/Audio/Wav/${FILENAME}.wav

#cellular on
cd ./files/quectel-CM
sudo ./quectel-CM -s fast.t-mobile.com &

sleep 10

#upload to s3 (need to update file paths)
sudo s3cmd put --reduced-redundancy --acl-public /home/pi/Audio/Upload/${FILENAME}.mp3 s3://soundscocoa/${FILENAME}.mp3

#cellular off
CELLULAR=$(pgrep quectel-CM)

sudo pgrep quectel-CM

sudo kill -KILL $CELLULAR

#moves mp3 from insternal storage to usb drive
sudo echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind
sudo mv /home/pi/Audio/Upload/${FILENAME}.mp3 /media/usb0
sudo echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind  
