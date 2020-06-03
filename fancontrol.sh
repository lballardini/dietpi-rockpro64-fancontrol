cooldown=15 # if fan is on + still on by next check let it on for n seconds
weblog=/var/log/index.html #location of your web-log file
prev=0 #variable for cycle-optimization (minimize sysfs writes)
inter=4 # check interval in seconds
run=1 #constant (on/off)
limit=45 # cpu temp target
refreshrate_webpage=4 #refresh on weblog in sec
web_icon() {
if ! [ -e "$weblog.png" ]
then
icon='iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACTklEQVRYR81Xyy4EQRS91RohJrERYsFEiAWJR7zCxhdYSFiIsPMbwn+IsLCRsPABNoIYCQk774hIxEYmHmNMX7eYGrdrukf10NoknUlX3zr39Kl7T1UL+MFvdBdRTl8bEKJYmKInyoSREJjeR3w6B3t1XGQ4geFNtBtjkF7qCaZGIAVkciW1TMQJ6M9MlyQQAQnKEyXfPtPE7K90oSqg0igSOoGgySWepwImcvIYCeSX/DusHIHRHUwSnSrVUmpiobcqJiZbNw+Up9qlgCqoD5kzEI+Vw0VWoT0i0a8X1eQ2NpeUwYkctxxoWOwT13rMdAKP6aXaJOJDClqtEjhVMepFvxTImgoHUcWlq8CTq3gvEnqtcOw8AuohV6LMAiinixMI0gUy9sUBSNOlv7m6zykwlcBZspBOFNAlEBq/6+NCPuA3l7CvCPuA3ORwuVfMuWpAr2oF4pD1WKxXnl6hcnVQPMvnuhXP7GNlCuDRby4nplR1taFfVetrqdZPJ6Du/WrHC9/ICflEV7d4aC3JmbRnXg0UWnMdcGwP6zIO3PI5aRtqNnrEvRwLncDIFtbbNtxwAlgBtesd4i50AqEuQaRFGHkbfhiRBR2A0EXrGA/DiAjzkvaGA8pxSD4w7zKisKw4RTb8amLFXsXlZygTCWwqFXDGVbItiC90iys+FmgzCrodcxLpFMRXhtzJs+14RP/tdDlJhBba5nOk87fjqA8kXtLJMZOjlmmcF5bRXqB3ROiHUpN9Qcb8+bH833yYRPZppi9NJB+nnMRvEHgHEXW/MAUnFpQAAAAASUVORK5CYII='
echo "$icon" > icon.png.base64
base64 -d "icon.png.base64" > "$weblog\.png"
cp $weblog\.png /var/www/html
fi
echo "<br><br><br><img src=\"index.html.png\" alt=\"cooldown active\"><br>System in cooldown mode for $cooldown seconds" >> $weblog
}
set_low() {
if ! [ $prev -eq 0 ]
then
echo "0" > /sys/class/hwmon/hwmon0/pwm1 && echo "set to low" && prev=0
else
echo "nothing changed"
fi
}
set_high() {
if ! [ $prev -eq 255 ]
then
echo "255" > /sys/class/hwmon/hwmon0/pwm1 && echo "set to high" && prev=255
else
echo "nothing changed"
echo "entered cooldown of $cooldown seconds" && web_icon && sleep $cooldown
fi
}
probe() {
temp=$(/boot/dietpi/dietpi-cpuinfo | grep Temperature | sed "s/'C.*//" | tail -c 3 | sed 's/[^0-9]*//g')
wdate=$(date)
echo "$temp CPU Temp <br> last eval: $wdate <br> target: $limit" > $weblog
echo "<meta http-equiv=\"refresh\" content=\"$refreshrate_webpage\"><br>" >> $weblog
if [ $prev -eq 0 ]
then
echo 'fan: not running<br>' >> $weblog
else
echo 'fan: running<br>' >> $weblog
fi
}
check() {
if [ $temp -ge $limit ]
then
set_high
else
set_low
fi
}
while [ $run -eq 1 ]
do
sleep $inter && probe && check
done
