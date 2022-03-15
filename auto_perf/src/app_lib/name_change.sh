#!/bin/bash
subfolders=$(ls ./malware)
for subfolder in $subfolders
do
    if test -f $subfolder; then
        echo "$subfolder is a file"
    else
        files=$(ls ./malware/$subfolder)
        for file in $files
        do
            if test -f ./malware/$subfolder/$file; then
                echo "./malware/$subfolder/$file"
                mv ./malware/$subfolder/$file ./malware/$subfolder/$file.apk
            fi
        done
    fi
done