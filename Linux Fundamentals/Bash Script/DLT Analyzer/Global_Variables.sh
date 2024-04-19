#!/bin/bash


report_file="report_logs.txt"
extraced_log_file="extraced_logs.log"
log_directory="."
log_entries=() 
# Global arrays of keywords for each log level
declare -a ERROR_KEYWORDS=("error" "failed" "exception" fatal "unable" "invalid" "not found" "permission denied" 
"segmentation fault" "syntax error" "timeout" "connection refused" "file not found" "out of memory" "stack overflow")
declare -a WARNING_KEYWORDS=("warning" "alert" "notice" "caution" "deprecated" "potential issue" "advisory" "non-fatal" 
"possible" "problem" "minor issue" "insecure" "incomplete" "deprecated" "obsolete" "pending")
declare -a DEBUGGING_KEYWORDS=("debug" "verbose" "trace" "info" "detail" "diagnostic" "log" "verbose"
"trace" "information" "detailed" "debugging" "inspection" "analysis")

# Global counters for counting number of log levels
declare -i ERROR_COUNTS=0
declare -i WARNING_COUNTS=0
declare -i DEBUGGING_COUNTS=0

# Global arrays of messages for each log level
declare -a ERROR_MESSAGES=()
declare -a WARNING_MESSAGES=()
declare -a DEBUGGING_MESSAGES=()
declare -a INFO_MESSAGES=()

# Global variables of keywords for each system events
declare startup_message="System Startup Sequence Initiated"
declare health_check_message="System health check OK"


# Definitions
declare -i ERROR=0
declare -i WARNING=1
declare -i DEBUGGING=2
declare -i INFO=3
declare -i ALL_LOGS=4
