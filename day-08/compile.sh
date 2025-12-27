#!/bin/bash

echo "$1"

filename="part$1"
java_name="${filename}.java"

javac "$java_name"

if [ $? -ne 0 ];then
    echo "Erreur de compilation"
    exit 1
fi
time java "$filename"