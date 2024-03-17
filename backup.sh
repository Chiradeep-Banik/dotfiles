#!/bin/sh

DESTINATION_FOLDER="/home/banik/Desktop/Code/"
SOURCE_FOLDER="/home/banik"

DATETIME=$(date +"D_%d_%m_%Y_T_%H_%M_%S");
FILENAME="backup_$DATETIME.tar.xz";

tar \
    --exclude=Videos\
    --exclude=Desktop/Code \
    --exclude=.local \
    --exclude=.cache \
    --exclude=.vscode-insiders  \
    --exclude=Downloads/MobiAct_Dataset_v2.0.rar  \
    -cvJf "$DESTINATION_FOLDER/$FILENAME"  \
    "$SOURCE_FOLDER"

if [ $? -eq 0 ]; then
    echo "Backup Created Successfully";
else
    echo "Backup Un-Successfully";
fi