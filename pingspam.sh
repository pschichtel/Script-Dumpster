#!/bin/bash

function printError ()
{
	echo -e "\033[41m\033[37m\033[4m"$1"\033[0m"
}

function pingspam ()
{
    echo "Starting pingspam... $2 ping processes"
    declare -i counter=1
    while [ $counter -le $2 ]
    do
        ping $1 > /dev/null &
        if [ $(expr $counter % 20) -eq 0 ]
        then
            echo "waiting a second..."
            sleep 1
        fi
        counter=$counter+1
    done
    echo "Done"
}

function checkdependencies ()
{
    if [ -z "$(which killall)" ]
    then
        return 1
    elif [ -z "$(which ping)" ]
    then
        return 1
    else
        return 0
    fi
}

function killping ()
{
    killall -e ping > /dev/null
}

if [ $# -lt 3 ]
then
	printError "Usage: pingspam <host> <processcount> <duration>"
	exit 1
fi

declare -i dependencies=$(checkdependencies)
if [ $dependencies -gt 0 ]
then
	printError "Script depends on ping and killall!"
    exit 1
fi

pingspam $1 $2
echo "Spam is running for $3 seconds..."
sleep $3
echo "Killing ping processes...";
killping > /dev/null
echo "done"
exit 1
