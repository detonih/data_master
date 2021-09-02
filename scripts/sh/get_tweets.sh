#!/bin/bash

hashtag=$1
# date_since format = yyyy-mm-dd
date_since=$2
number_items=$3
file_path=$4

if [ "$#" -ne 4 ]; then
  echo "Wrong number of paramters"
  exit 1
fi

echo "Getting tweets..."
python3 /scripts/python/get_tweets.py ${hashtag} ${date_since} ${number_items} ${file_path}
if [ $? -eq 0 ]; then
    echo "Tweets loaded into ${file_path}"
    if [ -f "$file_path" ]; then
        echo "Putting $file_path to hdfs..."
        hdfs dfs -put -f ${file_path} /stage/tweets.csv

        if [ $? -eq 0 ]; then
            echo "Put file done"
            echo "Deleting tweets raw data"

            rm -rf ${file_path}
            if [ $? -eq 0 ]; then
              echo "${file_path} deleted"
              exit 0
            else
              echo "problem trying to delete $file_path"
              exit 1
            fi
    
        else
            echo "We have a problem putting $EXTRACTED_FILE on hdfs"
            exit 1
        fi
    else
        echo "$file_path does not exist."
        exit 1
    fi
else
    echo "We have a problem trying to get tweets"
    exit 1
fi