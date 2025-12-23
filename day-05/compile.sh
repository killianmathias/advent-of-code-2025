#!/bin/bash

echo "$1"

filename="part$1"
rust_name="${filename}.rs"

rustc "$rust_name"

if [ $? -ne 0 ];then
    echo "Erreur de compilation"
    exit 1
fi
time ./"$filename"