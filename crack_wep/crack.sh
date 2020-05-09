#!/bin/bash

bssid=$1

echo "Fahre fort, wenn du mindestens 10000 Pakete empfangen hast (siehe airodump-ng)"
echo 
echo "Drücke eine beliebige Taste um fortzufahren..."
read -sn1

clear
aircrack-ng -b $bssid "dumps/dump-01.cap"

killall -e "airodump-ng"
killall -e "aireplay-ng"

read -sn1