# avianalysis
sound recording stuff

These programs are written in bash to allow for minimal dependencies and ease of deployment. These scripts and programs rely on crontab in order to perform their scheduled functions.


### sound.sh 
This should be ran at local sunrise in order to begin recording for the set duration, followed by an upload to S3. This script then powers down non-essential functions in order to conserve energy until the next morning. 


### sunwait
This program handles the calculation for local time sunrise in order to call the sound.sh script. 
