#!/usr/bin/env bash

# Declaration of variables
declare -A tableau 
rows=0
cols=0
total=0

declare -a positions=("-1 -1" "-1 0" "-1 1" "0 -1" "0 1" "1 -1" "1 0" "1 1")

# Function that read the file line by line and initialize cols, rows and array
read_file(){
    while IFS= read -r ligne || [ -n "$ligne" ]; do

        length=${#ligne}
        if (( length > cols )); then
            cols=$length
        fi

        for ((i=0; i<length; i++)); do
            tableau["$rows,$i"]="${ligne:i:1}"
        done
        ((rows++))
    done < "$1"
}

#Function that calculate the number of roll of paper accessible
calculate_accessible() {
    for ((i=0; i<rows; i++)); do
        for ((j=0; j<cols; j++)); do
            compteur=0
            
            if [[ "${tableau[$i,$j]}" == "@" ]];then
                
                for pos in "${positions[@]}"; do
                    read -r new_row new_col <<< "$pos"
                    new_i=$((i + new_row))
                    new_j=$((j + new_col))

                    if (( new_i >= 0 && new_i < rows && new_j >= 0 && new_j < cols )); then
                        if [[ "${tableau[$new_i,$new_j]}" == "@" ]]; then
                            ((compteur++))
                        fi
                    fi
                done

                if [[ $compteur -lt 4 ]];then
                    ((total++))
                fi
            fi
        done
    done
}

# Final result
input_file="input.txt"
read_file $input_file
calculate_accessible
echo "$total"