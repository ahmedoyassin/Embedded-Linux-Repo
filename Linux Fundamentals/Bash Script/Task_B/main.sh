#!/usr/bin/bash

declare process_options=("Process Information" 
                "Kill a Process"
                "Process Statistics"
                "Real-time Monitoring"
                "Search and Filter"
                "Resource Usage Alerts")
declare selectiion=""
declare PROCESS_NAME
#------------------------------------- function source ---------------------------------------#
# Source the utils file
if [ -f "utils.sh" ]; then
    source utils.sh
else
echo "utils file is not found"
fi

# Source the conf file
if [ -f "./process_monitor.conf" ]; then
    source process_monitor.conf
else
echo "conf file is not found"
fi

# Source the log file
if [ -f "./process_monitor.log" ]; then
    source process_monitor.log
else
echo "log file is not found"
fi

#------------------------------------- main function  ---------------------------------------#

function main() {
    echo "Select an option"

    select selectiion in "${process_options[@]}"; do
            echo "=================================================================================="
            echo "$selectiion:"
            echo "=================================================================================="

           
    case "$selectiion" in
            "${process_options[0]}")
                Proccess_Display
            ;;
            "${process_options[1]}")
                echo "Enter the id of the process you wish to be killed :)"
                read -r PID
                KILL "$PID"
            ;;
            "${process_options[2]}")
                Process_Statistics
            ;;
            "${process_options[3]}")
                realtimeMonitoring
            ;;
            "${process_options[4]}")
                echo "Enter search for processes based on criteria such as name, user, or resource usage: " 
                read -r PROCESS_NAME
                SEARCH_FILTER
            ;;
            "${process_options[5]}")
            ResourceUsageAlerts
            ;;
    esac
    done
}

main ""