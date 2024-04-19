#!/bin/bash
source Global_Variables.sh
source manage_files.sh
source DLT_filteration.sh
source check.sh
source report.sh
#source timestamp.sh

main(){
    extraced_file_creation
    DLT_log_iteration
 while true; do
    echo ""
    echo "DLT Log Analyzer"
    echo "1. Display System logs"
    echo "2. Filtering by log level"
    echo "3. Error and Warning Summary"
    echo "4. Summarized Report"
    echo "5. Exit"
    read -r -p "Please Enter a Choice: " choice
    echo -e "\n"

    case $choice in
        1)
        DLT_print_logs "$ALL_LOGS"
        ;;
        2)
        DLT_Filtration
        ;;
        3)
        Report_Issued
        ;;
        4)
        Report_File_Creation
        Report_Summary >> "$report_file"
        ;;
        5)
        break
        ;;
        *)
        echo "Sorry, I don't recognize that Choice."
        ;;
    esac
    done
}

main