#!/bin/bash


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
            formatted_timestamp=$(DLT_convert_timestamp_format "$timestamp")

            # Append formatted log entry to the array
            log_entries+=( "$formatted_timestamp $log_level $message" )
            
            DLT_count_log_levels "$formatted_timestamp" "$log_level" "$message"
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