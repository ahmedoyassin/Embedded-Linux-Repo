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

function CPU_USAGE() {
    local pid="$1"
    local cpu_threshold=${CPU_THRESHOLD:-90}
    if [ -d "/proc/$pid" ]; then
        # Read process CPU usage
        cpu_usage=$(awk '/^cpu /{print $2+$4}' "/proc/$pid/stat")
        if [ -n "$cpu_usage" ]; then
            if [  "$cpu_usage" -gt "$cpu_threshold" ]; then
                echo "$(date +'%Y-%m-%d %H:%M:%S') - Process $pid has exceeded CPU threshold ($cpu_threshold%): CPU usage is $cpu_usage%" >>"$CONFILE"
            fi
        fi
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Error: Process $pid not found." >>"$CONFILE"
    fi

}

function MEM_USAGE() {
    local pid="$1"
    local memory_threshold=${MEMORY_THRESHOLD:-90}
    if [ -d "/proc/$pid" ]; then
        # Read process memory usage
        memory_usage=$(awk '/VmRSS/{print $2}' "/proc/$pid/status")

        if [ -n "$memory_usage" ]; then
            if [ "$memory_usage" -gt "$memory_threshold" ]; then
                        echo "$(date +'%Y-%m-%d %H:%M:%S') - Process $pid has exceeded memory threshold ($memory_threshold KB): Memory usage is $memory_usage KB" >>"$CONFILE"
            fi
        fi
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Error: Process $pid not found." >>"$CONFILE"

    fi
}
function ResourceUsageAlerts() {
    while true; do
        # list of all process IDs
        pids=$(ls -1 /proc/ | grep -E "^[0-9]+$")

        for pid in $pids; do
            CPU_USAGE "$pid"
            MEM_USAGE "$pid"
        done
    done
}