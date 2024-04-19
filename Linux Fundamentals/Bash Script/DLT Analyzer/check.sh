#!/bin/bash



DLT_check_error(){

    local message="$1"
    local logs="$2"
    
    # Loop over ERROR keywords
    for keyword in "${ERROR_KEYWORDS[@]}"; do
        if [[ $message =~ $keyword ]]; then
            logs="ERROR!"
            break
        fi
    done
    
    echo "$logs"

}

DLT_check_warning(){

    local message="$1"
    local logs="$2"
    
    # Loop over WARNING keywords
    for keyword in "${WARNING_KEYWORDS[@]}"; do
        if [[ $message =~ $keyword ]]; then
            logs="WARNING!"
            break
        fi
    done
    
    echo "$logs"
}

DLT_check_debugging(){

    local message="$1"
    local logs="$2"
    
    # Loop over DEBUGGING keywords
    for keyword in "${DEBUGGING_KEYWORDS[@]}"; do
        if [[ $message =~ $keyword ]]; then
            logs="DEBUGGING!"
            break
        fi
    done
    
    echo "$logs"

}

