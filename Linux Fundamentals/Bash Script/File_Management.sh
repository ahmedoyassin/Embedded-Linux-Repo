#!/usr/bin/bash


# ________________________________________ Variables ______________________________________
declare directory

# ________________________________________ Functions ______________________________________

function declareDirectory () {
    
    # Declare directory paths for different file types
    txt_dir="$directory/txt_files"
    pdf_dir="$directory/pdf_files"
    jpg_dir="$directory/jpg_files"
    misc_dir="$directory/misc_files"

        # Create subdirectories if they don't exist
    mkdir -p "$txt_dir" "$jpg_dir" "$pdf_dir" "$misc_dir"
}

function moveFile () {

    # Check if any files types are found
    for file in "${directory}/"*; do
    if [[ $file == *.txt ]]; then
        if [ -f "$file" ]; then
    mv "$file" "$txt_dir"
    fi
    elif [[ $file == *.jpg ]]; then
        if [ -f "$file" ]; then
    mv "$file" "$jpg_dir"
    fi
    elif [[ $file == *.pdf ]]; then
        if [ -f "$file" ]; then
    mv "$file" "$pdf_dir"
    fi
    else
        if [ -f "$file" ]; then
    mv "$file" "$misc_dir"
    fi
    fi
    done
}


function fileSearchExtenstion () {
    directory="$1"

# Check if any files types are found
for file in "${directory}/"*; do
    if [[ $file == *.txt ]]; then
        echo "|-- txt/ "
    echo "|   |--    $(basename "$file")"
    elif [[ $file == *.jpg ]]; then
        echo "|-- jpg/ "
    echo "|   |--    $(basename "$file")"
    elif [[ $file == *.pdf ]]; then
            echo "|-- pdf/ "
    echo "|   |--    $(basename "$file")"
    else
            if [ -f "$file" ]; then
            echo "|-- misc/ "
    echo "|   |--    $(basename "$file")"
    fi
fi

done
}


# ________________________________________ main function ______________________________________
function main () {
    echo "Downloads/"
    directory=$1
    # Checks if the given directory exists
    if [ -d "$directory" ]; then
    # echo "directory \"$directory\" exists"
      declareDirectory "$directory"
    fileSearchExtenstion "$directory"
    moveFile "$directory"
  else
  echo "directory not found"
  fi
}


# Main Call.
main $1