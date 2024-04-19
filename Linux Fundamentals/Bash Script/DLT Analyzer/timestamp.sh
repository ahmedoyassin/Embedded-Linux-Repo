#!/bin/bash

DLT_TimeStamp(){
    local old_timestamp="$1"
    local month="${old_timestamp:0:3}"
    local day="${old_timestamp:4:2}"    
    local time="${old_timestamp:7:8}"   
    local year="$(date +'%y')"          
    month="$(DLT_Month_Selection "$month")"

    local timestamp=$"[20${year}-${month}-${day} ${time}]"
    echo "$timestamp"
}
DLT_Month_Selection(){
    local month="$1"
    case $month in
    "Jan")
        month="01"
        ;;
    "Feb")
        month="02"
        ;;
    "Mar")
        month="03"
        ;;
    "Apr")
        month="04"
        ;;
    "May")
        month="05"
        ;;
    "Jun")
        month="06"
        ;;
    "Jul")
        month="07"
        ;;
    "Aug")
        month="08"
        ;;
    "Sep")
        month="09"
        ;;
    "Oct")
        month="10"
        ;;
    "Nov")
        month="11"
        ;;
    "Dec")
        month="12"
        ;;
    *)
        echo "Sorry, I don't recognize that Month."
        ;;
esac

	echo "$month"

}