#!/bin/bash

#DLT_TimeStamp(){
DLT_convert_timestamp_format() {
    local old_timestamp="$1"
    local month="${old_timestamp:0:3}"
    local day="${old_timestamp:4:2}"    
    local time="${old_timestamp:7:8}"   
    local year="$(date +'%y')"          
    month="$(DLT_convert_month_format "$month")"

    local timestamp=$"[20${year}-${month}-${day} ${time}]"
    echo "$timestamp"
}
#DLT_Month_Selection(){
DLT_convert_month_format() {
    local month="$1"
    case $month in
    "January")
        month="01"
        ;;
    "February")
        month="02"
        ;;
    "March")
        month="03"
        ;;
    "Apirl")
        month="04"
        ;;
    "May")
        month="05"
        ;;
    "June")
        month="06"
        ;;
    "July")
        month="07"
        ;;
    "August")
        month="08"
        ;;
    "September")
        month="09"
        ;;
    "October")
        month="10"
        ;;
    "November")
        month="11"
        ;;
    "December")
        month="12"
        ;;
    *)
        echo "Sorry, I don't recognize that Month."
        ;;
esac

	echo "$month"

}