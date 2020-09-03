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
echo "[status]: run 'sudo ./Record_from_Linein_Micbias.sh'" >> $LOG
sudo ./Record_from_Linein_Micbias.sh
echo "[status]: cmd record finished" >> $LOG

echo "[status]: set AUDIDEV variable" >> $LOG
export AUDIDEV=hw:1,0

echo "[status]: initiate record 30 minutes of audio" >> $LOG
#Records 30 min of audio
rec -c 2 -r 44800 -b 16 /home/pi/Audio/Wav/${FILENAME}.wav bandpass 720 600 highpass 120 gain 20 trim 2 32
echo "[status]: 30 minutes of audio finished recording" >> $LOG

#converts from .wav to .mp3
echo "[status]: begin .wav to .mp3 conversion" >> $LOG
sudo lame -b 64 /home/pi/Audio/Wav/${FILENAME}.wav /home/pi/Audio/Upload/${FILENAME}.mp3
echo "[status]: conversion complete" >> $LOG

#deletes .wav file
echo "[status]: attempt to delete .wav file" >> $LOG
sudo rm /home/pi/Audio/Wav/${FILENAME}.wav
echo "[status]: rm cmd completed" >> $LOG

#cellular on
echo "[status] cd and turn cellular on" >> $LOG
cd ./files/quectel-CM
sudo ./quectel-CM -s fast.t-mobile.com &
echo "[status] cellular cmd executed, and in background" >> $LOG

echo "[status] sleep for 10 count" >> $LOG
sleep 10
echo "[status] sleep completed" >> $LOG

#upload to s3 (need to update file paths)
echo "[status] upload to s3" >> $LOG
sudo s3cmd put --reduced-redundancy --acl-public /home/pi/Audio/Upload/${FILENAME}.mp3 s3://soundscocoa/${FILENAME}.mp3
echo "[status] upload cmd complete" >> $LOG

#cellular off
echo "[status] turn cellular off" >> $LOG
echo "[status] grep cellular process ID" >> $LOG
CELLULAR=$(pgrep quectel-CM)
echo "cellular pid = $CELLULAR" >> $LOG

sudo pgrep quectel-CM

echo "[status] kill celular" >> $LOG
sudo kill -KILL $CELLULAR
echo "[status] cellular off" >> $LOG


#moves mp3 from internal storage to usb drive
echo "[status] move mp3 from internal storage to usb drive" >> $LOG
sudo echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind
sudo mv /home/pi/Audio/Upload/${FILENAME}.mp3 /media/usb0
sudo echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind  
echo "[status] bash script complete" >> $LOG