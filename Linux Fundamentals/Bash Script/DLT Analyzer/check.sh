#!/bin/bash

# Global arrays of keywords for each log level
declare -a ERROR_KEYWORDS=("error" "failed" "exception" fatal "unable" "invalid" "not found" "permission denied" 
"segmentation fault" "syntax error" "timeout" "connection refused" "file not found" "out of memory" "stack overflow")
declare -a WARNING_KEYWORDS=("warning" "alert" "notice" "caution" "deprecated" "potential issue" "advisory" "non-fatal" 
"possible" "problem" "minor issue" "insecure" "incomplete" "deprecated" "obsolete" "pending")
declare -a DEBUGGING_KEYWORDS=("debug" "verbose" "trace" "info" "detail" "diagnostic" "log" "verbose"
"trace" "information" "detailed" "debugging" "inspection" "analysis")



DLT_Check_Error(){

    local message="$1"
    local logs="$2"
    
    # Loop over ERROR keywords
    for keyword in "${ERROR_KEYWORDS[@]}"; do
        if [[ $message =~ $keyword ]]; then
            logs="ERROR"
            break
        fi
    done
    
    echo "$logs"

}

DLT_Check_Warning(){

    local message="$1"
    local logs="$2"
    
    # Loop over WARNING keywords
    for keyword in "${WARNING_KEYWORDS[@]}"; do
        if [[ $message =~ $keyword ]]; then
            logs="WARNING"
            break
        fi
    done
    
    echo "$logs"
}

DLT_Check_Debugging(){

    local message="$1"
    local logs="$2"
    
    # Loop over DEBUGGING keywords
    for keyword in "${DEBUGGING_KEYWORDS[@]}"; do
        if [[ $message =~ $keyword ]]; then
            logs="DEBUGGING"
            break
        fi
    done
    
    echo "$logs"

}


DLT_Check_Logs() {
    local message="$1"
    local logs="INFO"
    
    logs=$(DLT_Check_Error "$message" "$logs")
        
    if [[ $logs == "INFO" ]]; then
    logs=$(DLT_Check_Warning "$message" "$logs")
    fi
        
    if [[ $logs == "INFO" ]]; then
    logs=$(DLT_Check_Debugging "$message" "$logs")
    fi
    
    echo "$logs"
}