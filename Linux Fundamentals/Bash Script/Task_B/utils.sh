#!/usr/bin/bash

declare CONFILE="process_monitor.log"

function    Proccess_Display() {
    clear
    printf "%-5s %-10s %-10s %-10s %-10s %-20s\n" "PID" "TTY" "STAT" "CPU %" "MEM %" "COMMAND"
     for pid in $(ls /proc | grep -E '^[0-9]+$'); do
        if [ -d "/proc/$pid" ]; then
            tty=$(readlink /proc/"$pid"/fd/0 | cut -d/ -f3 | sed 's/\(.*\)/\1/')
            if [ -z "$tty" ]; then
                tty="? "
            fi
            stat=$(awk '/State:/ {print $2}' /proc/"$pid"/status)
            if [ -z "$stat" ]; then
                stat="?"
            fi
            cpu=$(awk '{print $14 + $15}' /proc/"$pid"/stat)
            mem=$(awk '{print $24}' /proc/"$pid"/stat)
            if [ -z "$cpu" ]; then
                cpu="?"
            fi
            if [ -z "$mem" ]; then
                mem="?"
            fi
            cmd=$(tr -d '\0' </proc/"$pid"/comm | cut -d' ' -f1)
            if [ -z "$cmd" ]; then
                cmd="[???]"
            fi
            printf "%-5s %-10s %-10s %-10s %-10s %-20s\n" "$pid" "$tty" "$stat" "$cpu" "$mem" "$cmd"
        fi
    done

}

function    KILL() {
    local pid
    pid=$1
    if [[ -z $PID ]]; then
        PRINT_IN_CONF "NO SUCH A PROCESS ID"
    else
        kill "$PID"
        if [[ $? -eq 0 ]]; then
        PRINT_IN_CONF "killed successfully"
        else
        PRINT_IN_CONF "Faild to kill the PID $pid"
        fi
    fi


}

function    Process_Statistics() {
    echo "Total Number of processes :$(ps -e | wc -l)" 
    echo "Memory Usage: $(free -m | grep Mem | awk '{print $3 " MB used out of " $2 " MB"}')"
    echo "CPU Load: $(uptime)"
}

function realtimeMonitoring() {
    trap 'return' SIGINT
    while true; do
        clear
        # Display process information
        Proccess_Display
    done

}


function    SEARCH_FILTER() {
    local PROCESS_NAME
    PROCESS_NAME=$1
    pgrep -fl "$PROCESS_NAME"
}

function ResourceUsageAlerts() {

}