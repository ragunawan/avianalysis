#!/bin/bash

### Variable Declarations
FILENAME=$(date +"%Y%m%d_%H%M")
LOG="/home/pi/sound4-$FILENAME.log"

##-begin log
touch $LOG
echo $FILENAME > $LOG
echo "[status]: Called by crontab" >> $LOG

### Audio Recording Code
#Executed by Crontab 30min before sunrise
#Records 30 min of audio, converts to MP3, deletes .wav file, uploads to AWS, deletes WAV after sucessful upload, goes on low power mode

#Loads audio device
echo "[init]: run 'sudo ./Record_from_Linein_Micbias.sh'" >> $LOG
sudo ./Record_from_Linein_Micbias.sh
echo "[return]: cmd record finished" >> $LOG

echo "[init]: set AUDIDEV variable" >> $LOG
export AUDIDEV=hw:1,0

echo "[init]: initiate record 30 minutes of audio" >> $LOG
#Records 30 min of audio
rec -c 2 -r 44100 -b 16 /home/pi/home/pi/Audio/Wav/${FILENAME}.wav gain 32 trim 2 32
echo "[return]: 30 minutes of audio finished recording" >> $LOG

#converts from .wav to .mp3
echo "[init]: begin .wav to .mp3 conversion" >> $LOG
sudo lame -b 128 /home/pi/home/pi/Audio/Wav/${FILENAME}.wav /home/pi/home/pi/Audio/Upload/${FILENAME}.mp3
echo "[return]: conversion complete" >> $LOG

#deletes .wav file
echo "[init]: attempt to delete .wav file" >> $LOG
sudo rm /home/pi/home/pi/Audio/Wav/${FILENAME}.wav
echo "[return]: rm cmd completed" >> $LOG

#cellular on
echo "[init] cd and turn cellular on" >> $LOG
cd ./files/quectel-CM
sudo ./quectel-CM -s fast.t-mobile.com &
echo "[return] cellular cmd executed, and in background" >> $LOG

echo "[init] sleep for 10 count" >> $LOG
sleep 10
echo "[return] sleep completed" >> $LOG

#upload to s3 (need to update file paths)
echo "[init] upload to s3" >> $LOG
sudo s3cmd put --reduced-redundancy --acl-public /home/pi/home/pi/Audio/Upload/${FILENAME}.mp3 s3://soundscocoa/${FILENAME}.mp3
echo "[return] upload cmd complete" >> $LOG

#cellular off
echo "[status] turn cellular off" >> $LOG
echo "[init] grep cellular process ID" >> $LOG
CELLULAR=$(pgrep quectel-CM)
echo "[return] cellular pid = $CELLULAR" >> $LOG

sudo pgrep quectel-CM

echo "[init] kill celular" >> $LOG
sudo kill -KILL $CELLULAR
echo "[return] cellular off" >> $LOG


#moves mp3 from internal storage to usb drive
echo "[status] move mp3 from internal storage to usb drive" >> $LOG
sudo echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind
echo "[init] mv command from local storage to USB"
sudo mv /home/pi/home/pi/Audio/Upload/${FILENAME}.mp3 /media/usb0
sudo echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind
echo "[return] file move complete" >> $LOG
echo "[status] bash script complete" >> $LOG
