#!/bin/bash

report_file="report_logs.txt"
extraced_log_file="extraced_logs.log"
log_directory="."
log_entries=()

# Global arrays of messages for each log level
declare -a ERROR_MESSAGES=()
declare -a WARNING_MESSAGES=()
declare -a DEBUGGING_MESSAGES=()
declare -a INFO_MESSAGES=()

Report_File_Creation() {
  truncate -s 0 $report_file
  if [[ ! -f "$report_file" ]]; then
    touch "$report_file"  # Create the file if it doesn't exist
  fi
}
extraced_file_creation() {
  truncate -s 0 $extraced_log_file
  if [[ ! -f "$extraced_log_file" ]]; then
    touch "$extraced_log_file"  # Create the file if it doesn't exist
  fi
  DLT_print_logs "$ALL_LOGS" >> "$extraced_log_file"
}

# Function to extract and print log information
DLT_extract_log_info() {
    local log_file="$1"
    local pattern="^([A-Za-z]{3}\s+[0-9]{1,2}\s[0-9]{2}:[0-9]{2}:[0-9]{2})\s([^ ]+)\s(.*)$"

    while IFS= read -r line; do
        if [[ $line =~ $pattern ]]; then
            timestamp="${BASH_REMATCH[1]}"
            
            #Replace every "all_Char: " with nothing so it is /empty/
 	    message=$(echo "${BASH_REMATCH[3]}" | sed 's/.*: //')
 	    log_level="$(DLT_check_log_level "$message")"
            
            # Convert and format timestamp
            formatted_timestamp=$(DLT_TimeStamp "$timestamp")

            # Append formatted log entry to the array
            log_entries+=( "$formatted_timestamp $log_level $message" )
            
            DLT_count_log_levels "$formatted_timestamp" "$log_level" "$message"
        fi
    done < "$log_file"
}

DLT_log_iteration() {
    local log_files=( "$log_directory"/*.log )

    for file in "${log_files[@]}"; do
        #echo "Logs for file: $file"
        DLT_extract_log_info "$file"
    done
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
