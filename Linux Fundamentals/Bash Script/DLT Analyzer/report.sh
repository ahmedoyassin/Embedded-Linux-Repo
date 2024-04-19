#!/bin/bash



Report_Summary(){
  echo "******************************************************************"
  echo "********************  System Events Started **********************"
  echo "******************************************************************"
  echo "***** Here's a Report Summary *****"
  Report_Errors
	Report_Warnings
	Report_Debugging
	Report_Info
  Report_System_Traffic
}

Report_Issued(){

  echo "***** Here's a Report Issued *****"
  Report_Errors
	Report_Warnings

}



Report_Errors(){
  if [[ ${#ERROR_MESSAGES[@]} -gt 0 ]]; then
    echo "** Errors:** $ERROR_COUNTS errors were found."

  else
    echo "No errors detected."
  fi
}

Report_Warnings(){
  if [[ ${#WARNING_MESSAGES[@]} -gt 0 ]]; then
    echo "** Warnings:** $WARNING_COUNTS warns were found."

  else
    echo "No warns detected."
  fi
}

Report_Debugging(){
  if [[ ${#DEBUGGING_MESSAGES[@]} -gt 0 ]]; then
    echo "** Debugging:** $DEBUGGING_COUNTS debugs were found."

  else
    echo "No debugs detected."
  fi
}

Report_Info(){
  if [[ ${#INFO_MESSAGES[@]} -gt 0 ]]; then
    echo "** Info:** $INFO_COUNTS info events were found."

  else
    echo "No info events detected."
  fi
}

Report_System_Traffic(){
  echo "******************************************************************"
  echo "********************  System Events Started **********************"
  echo "******************************************************************"
  if grep -q "$startup_message" <<< "${log_entries[@]}"; then
    echo "** Startup Sequence:** Initiated successfully."
  else
    echo "** Startup Sequence:** Not found in logs."
  fi


  if grep -q "$health_check_message" <<< "${log_entries[@]}"; then
    echo "** System Health Check:** Passed."
  else
    echo "** System Health Check:** Not found in logs."
  fi

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