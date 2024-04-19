#!/bin/bash

declare -i ERROR=0
declare -i WARNING=1
declare -i DEBUGGING=2
declare -i INFO=3
declare -i ALL_LOGS=4

DLT_extract_logs() {
    local log_file="$1"
    local pattern="^([A-Za-z]{3}\s+[0-9]{1,2}\s[0-9]{2}:[0-9]{2}:[0-9]{2})\s([^ ]+)\s(.*)$"

    while IFS= read -r line; do
        if [[ $line =~ $pattern ]]; then
            timestamp="${BASH_REMATCH[1]}"
            
 	    message=$(echo "${BASH_REMATCH[3]}" | sed 's/.*: //')
 	    log_level="$(DLT_Check_Logs "$message")"
            
            # Convert and format timestamp
            formatted_timestamp=$(DLT_TimeStamp "$timestamp")

            # Append formatted log entry to the array
            log_entries+=( "$formatted_timestamp $log_level $message" )
            
            DLT_Count_Logs "$formatted_timestamp" "$log_level" "$message"
        fi
    done < "$log_file"
}

DLT_print_logs(){
	local options="$1"
	
	if [ "$options" = "$ALL_LOGS" ]; then
	 printf '%s\n' "${log_entries[@]}"
	 
	elif [ "$options" = "$ERROR" ]; then
	 printf '%s\n' "${ERROR_MESSAGES[@]}"
	 
	elif [ "$options" = "$WARNING" ]; then
	 printf '%s\n' "${WARNING_MESSAGES[@]}"
	 
	elif [ "$options" = "$DEBUGGING" ]; then
	 printf '%s\n' "${DEBUGGING_MESSAGES[@]}"
	 
	elif [ "$options" = "$INFO" ]; then
	 printf '%s\n' "${INFO_MESSAGES[@]}"
	 	 	 	 
	fi

}

DLT_Filtration(){

    while true; do
    echo "Select a log level"
    echo "1.Error logs"
    echo "2.Warning logs"
    echo "3.Debuging logs"
    echo "4.Info logs"
    echo "5.Main"
    read -r -p "Enter your choice: " choice
    echo -e "\n"
    
    case $choice in
        1) DLT_print_logs "$ERROR" ;;
        2) DLT_print_logs "$WARNING" ;;
        3) DLT_print_logs "$DEBUGGING";;
        4) DLT_print_logs "$INFO";;
        5) echo "Back to Main."; break ;; 
        *) echo "Invalid choice. Please try again." ;;
    esac
done
}


DLT_Count_Logs(){
      local timestamp="$1"
      local log_level="$2"
      local message="$3"

      case $log_level in
        "ERROR")
          ((ERROR_COUNTS++))
          ERROR_MESSAGES+=("$timestamp $log_level  $message")
          ;;
        "WARNING")
          ((WARNING_COUNTS++))
          WARNING_MESSAGES+=("$timestamp $log_level  $message")
          ;;
        "DEBUG")
          ((DEBUG_COUNTS++))
          DEBUGGING_MESSAGES+=("$timestamp $log_level  $message")
          ;;
        *)
          ((INFO_COUNTS++))
          INFO_MESSAGES+=("$timestamp $log_level  $message")
          ;;
      esac
}

DLT_count_log_levels(){
      local timestamp="$1"
      local log_level="$2"
      local message="$3"

      case $log_level in
        "ERROR")
          ((ERROR_COUNTS++))
          ERROR_MESSAGES+=("$timestamp $log_level  $message")
          ;;
        "WARNING")
          ((WARNING_COUNTS++))
          WARNING_MESSAGES+=("$timestamp $log_level  $message")
          ;;
        "DEBUG")
          ((DEBUG_COUNTS++))
          DEBUGGING_MESSAGES+=("$timestamp $log_level  $message")
          ;;
        *)
          ((INFO_COUNTS++))
          INFO_MESSAGES+=("$timestamp $log_level  $message")
          ;;
      esac
}

DLT_log_iteration() {
    local log_files=( "$log_directory"/*.log )

    for file in "${log_files[@]}"; do
        DLT_extract_logs "$file"
    done
}