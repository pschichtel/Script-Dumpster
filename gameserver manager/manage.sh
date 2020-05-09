#!/bin/bash

function pause ()
{
    echo "Drücke eine beliebige Taste um fortzufahren..."
    read -sn1
}
function wait ()
{
    char="."
    if [ ! -z "$2" ]
    then
        char="$2"
    fi
    
    declare -i i=0
    while [ $i -lt $1 ]
    do
        echo -n "$char"
        sleep 1
        i=$((++i))
    done
    echo ""
}

function printMsg ()
{
    case $1 in
        ok)
            echo -e "\033[32m\033[4m"$2"\033[0m";;
        notice)
            echo -e "\033[33m\033[4m"$2"\033[0m";;
        warning)
            echo -e "\033[43m\033[30m\033[4m"$2"\033[0m";;
        error)
            echo -e "\033[41m\033[37m\033[4m"$2"\033[0m";;
        *)
            echo "$2";;
    esac
}

function server_exists ()
{
    if [ ! -e "$SERVERPATH/$NAME" ]
    then
        printMsg "error" "The given server does not exist!"
        printMsg "error" "Name: $NAME"
        exit 1
    fi
}
function server_not_exists ()
{
    if [ -e "$SERVERPATH/$NAME" ]
    then
        printMsg "error" "The given server does already exist!"
        printMsg "error" "Name: $NAME"
        exit 1
    fi
}

function trim()
{
    echo "$1" | sed 's/ *$//g'
}

function empty()
{
    if [ -z "$(trim "$1")" ]
    then
        return 0
    else
        return 1
    fi
}

function help_exit ()
{
    $0 -c help
    exit $1
}

function no_root ()
{
    if [ "${UID}" = "0" ]
    then
        printMsg "error" "The given command must not be run as root!"
        wait 3 "!"
        exit 1
    fi
}

function require_name ()
{
    if ( empty "$NAME" )
    then
        printMsg "error" "The name is missing!"
        help_exit 1
    fi
}

function c_start ()
{
    path="$SERVERPATH/$NAME"
    
    if [ -e "$path/$NAME.pid" ]
    then
        if ( kill -0 `cat "$path/$NAME.pid"` 2> /dev/null)
        then
            printMsg "notice" "The given server is already running!"
            exit 1
        else
            printMsg "warning" "PID found, but the server is not running!"
            rm -f "$path/$NAME.pid"
        fi
    fi
    
    if ( empty "$EXE" )
    then
        EXE=`cat "$path/$NAME.command" 2>/dev/null`
        if ( empty "$EXE" )
        then
            printMsg "notice" "No executable given, assuming '$DEFAULT_EXE'"
            EXE="$DEFAULT_EXE"
        fi
    fi
    
    echo "$EXE" > "$path/$NAME.command"
    
    if [ ! -e "$path/$EXE" ]
    then
        printMsg "error" "Server-executable not found!"
        help_exit 1
    fi
    if [ ! -x "$path/$EXE" ]
    then
        printMsg "notice" "Server-executable is not executable, trying to fix that..."
        chmod 755 "$path/$EXE"
        if [ ! -x "$path/$EXE" ]
        then
            printMsg "error" "Server-executable is not executable!"
        fi
    fi
    
    if ( empty $PARAMS )
    then
        if [ -e "$path/$NAME.params" ]
        then
            PARAMS=`cat "$path/$NAME.params"`
        fi
    else
        echo $PARAMS > "$path/$NAME.params"
    fi
    
    result=$(screen -L -q -dmS "managed__$NAME" "$path/$EXE" $PARAMS)
    pid="$(screen -list | grep "managed__$NAME" | cut -f1 -d'.' | sed 's/\W//g')"

    wait 3

    if ( ! kill -0 $pid 2> /dev/null )
    then
        printMsg "error" "The server did not start, check your startscript."
        exit 1
    fi

    echo "$pid" > "$path/$NAME.pid"
    
    if [ $REATTACH == 1 ]
    then
        screen -r $pid
    fi
    
    printMsg "ok" "Server $NAME started!"
    return 0
}
function c_restart ()
{
    $0 -c stop -n "$NAME" -sc "$STOP_COMMAND" && $0 -c start -n "$NAME" || exit 1
}
function c_status ()
{
    path="$SERVERPATH/$NAME"
    
    if [ -e "$path/$NAME.pid" ]
    then
        if ( kill -0 `cat "$path/$NAME.pid"` 2> /dev/null )
        then
            printMsg "ok" "Server is running"
            exit 0
        else
            printMsg "warning" "Server seems to have died"
            exit 1
        fi
    else
        printMsg "notice" "No server running (PID is missing)"
        exit 1
    fi
}
function c_stop ()
{
    path="$SERVERPATH/$NAME"
    
    if [ -e "$path/$NAME.pid" ]
    then
        pid=`cat "$path/$NAME.pid"`
        if [ ! -z "$STOP_COMMAND" ]
        then
            screen -S "managed__$NAME" -X stuff $(echo "$STOP_COMMAND")
            screen -S "managed__$NAME" -X stuff $'\n'
            echo "Stop command send"
            declare -i i=0
            while [ $i -lt 10 ]
            do
                if ( kill -0 $pid 2> /dev/null )
                then
                    echo -n "."
                    sleep 1
                else
                    break
                fi
                i=$((++i))
            done
            
            if ( kill -0 $pid 2> /dev/null )
            then
                echo ""
                printMsg "warning" "The stop command did not work. Killing the server now..."
                kill $pid 2> /dev/null
            else
                printMsg "ok" "done"
            fi
        else
            printMsg "ok" "Killing server"
            kill $pid 2> /dev/null
            
        fi
        
        rm -f "$path/$NAME.pid"
    else
        printMsg "notice" "There was no running server."
        exit 1
    fi
}
function c_view ()
{
    path="$SERVERPATH/$NAME"
    
    if ( $0 -c status -n "$NAME" )
    then
        screen -r `cat "$path/$NAME.pid"`
    else
        printMsg "notice" "The server is not running."
    fi
}
function c_list ()
{
    help_exit 0
}
function c_install ()
{
    if [ ! -e "$SCRIPTPATH/server.7z" ]
    then
        printMsg "error" "No game package found at '$SCRIPTPATH'"
        exit 1
    fi
    
    path="$SERVERPATH/$NAME"
    
    echo -n "Creating directory..."
    mkdir "$path" > /dev/null
    if [ $? != 0 ]
    then
        echo "failed"
        printMsg "error" "Failed to create the server directory!"
        exit 1
    fi
    echo "done"
    echo -n "Extracting..."
    7z x "-o$path" "$SCRIPTPATH/server.7z" > /dev/null
    if [ $? == 0 ]
    then
        echo "done"
        echo ""
        printMsg "ok" "The server is now installed and ready to start!"
        printMsg "ok" "Good luck and have fun!"
    else
        echo "failed"
        printMsg "error" "7-zip failed to extract the server files"
        exit 1
    fi
    
    if [ $START == 1 ]
    then
        echo ""
        echo "Starting the server now"
        $0 -c start -n "$NAME" -e "$EXE" -p "$PARAMS"
    fi
}
function c_remove ()
{
    path="$SERVERPATH/$NAME"
    echo -n "Sure to remove the server? All files will bei lost! [y|n] "
    read input
    if [ "$input" == "y" -o "$input" == "Y" ]
    then
        echo -n "Stopping the server (if running)..."
        $0 -c stop -n "$NAME" > /dev/null
        screen -wipe > /dev/null
        echo "done"
        echo -n "Removing server directory..."
        rm -R "$path"
        echo "done"
    else
        echo "Exiting..."
        exit 1
    fi
}
function c_help ()
{
    echo ""
    echo "Server Manager - Manual"
    echo ""
    echo "Usage: $0 -c <command> [params]"
    echo ""
    echo "Commands:"
    echo "    start: Starts the server"
    echo "    params:"
    echo "        -n name       name of the server"
    echo "        -e path       the server run script or executable"
    echo "        -p params     the params to give to the executable"
    echo "        --reattach    reattaches the screen after starting"
    echo ""
    echo "    stop: Stops the server"
    echo "    params:"
    echo "        -n name       name of the server"
    echo "        -sc command   the commands to stop the server"
    echo ""
    echo "    restart: Restarts the server (stop -> start)"
    echo "    params:"
    echo "        -n name       name of the server"
    echo ""
    echo "    status: Prints the current state of the server"
    echo "    params:"
    echo "        -n name       name of the server"
    echo ""
    echo "    view: Reattaches the server's screen"
    echo "    params:"
    echo "        -n name       name of the server"
    echo ""
    echo "    install: Installs a news server"
    echo "    params:"
    echo "        -n name       name of the server"
    echo "        --start       starts the server after install"
    echo ""
    echo "    remove: Removes a server"
    echo "    params:"
    echo "        -n name       name of the server"
    echo ""
}

if ( empty "$(which screen)" )
then
    printMsg "error" "GNU Screen is required to use this tool!"
    exit 1
fi

SCRIPTPATH="$(dirname "$(readlink -f "$0")")"
SERVERPATH="$SCRIPTPATH/servers"
COMMAND="help"
NAME=""
EXE=""
DEFAULT_EXE="run.sh"
PARAMS=""
REATTACH=0
STOP_COMMAND=""
START=0

if [ ! -e "$SERVERPATH" ]
then
    mkdir "$SERVERPATH"
fi

while [ $# -gt 0 ]
do
    case "$1" in
    "-c")
        COMMAND=$2
        shift
        ;;
    "-n")
        NAME="$(trim "$2")"
        shift
        ;;
    "-e")
        EXE="$2"
        shift
        ;;
    "-p")
        PARAMS="$2"
        shift
        ;;
    "--reattach")
        REATTACH=1
        ;;
    "-sc")
        STOP_COMMAND="$2"
        shift
        ;;
    "--start")
        START=1
        ;;
    esac
    shift
done

case "$COMMAND" in
    "start")
        no_root
        require_name
        server_exists
        c_start
        ;;
    "restart")
        c_restart
        ;;
    "status")
        require_name
        server_exists
        c_status
        ;;
    "stop")
        require_name
        server_exists
        c_stop
        ;;
    "view")
        require_name
        server_exists
        c_view
        ;;
    "list")
        c_list
        ;;
    "install")
        no_root
        require_name
        server_not_exists
        c_install
        ;;
    "remove")
        require_name
        server_exists
        c_remove
        ;;
    *)
        c_help
        exit 0
        ;;
esac

exit 0