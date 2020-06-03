# dietpi-rockpro64-fancontrol
Fan controller for dietpi running on RockPro64 with NGINX http interface 

Switches RockPro64 FAN-Port on and off, PWM modulation not yet implementet.
Has some intelligent features for simple hysteresis by sleeping for n seconds if target is not met in the second check-cycle.
This means that your fan will not switch on and off rapidly if the temperature goal is reached.

Needs NGINX (or any http server [may need to troubleshoot yourself]) for webinterface and base64 for embedded interface icons 

Dependencies:

base64
nginx

Installation: 
apt update -y && apt upgrade && apt install base64 -y && apt install nginx -y && apt install git -y && cd ~/ && git clone https://github.com/deadport/dietpi-rockpro64-fancontrol && cd dietpi-rockpro64-fancontrol && chmod +x fancontrol.sh && ./fancontrol.sh  
