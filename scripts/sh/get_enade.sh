#!/bin/bash

curl https://download.inep.gov.br/microdados/Enade_Microdados/microdados_enade_2019.zip -o /raw-data/microdados_enade_2019.zip

FILE=/raw-data/microdados_enade_2019.zip
if [ -f "$FILE" ]; then

    echo "Unziping file..."
    unzip /raw-data/microdados_enade_2019.zip -d /raw-data/
    if [ $? -eq 0 ]; then
        echo "File unziped successfully"
        EXTRACTED_FILE=/raw-data/3.DADOS/microdados_enade_2019.txt
        rm /raw-data/microdados_enade_2019.zip
    else
        echo "We have a problem unziping file"
    fi

    if [ -f "$EXTRACTED_FILE" ]; then
        echo "Putting $EXTRACTED_FILE to hdfs..."
        hdfs dfs -put -f /raw-data/3.DADOS/microdados_enade_2019.txt /stage/microdados_enade_2019.txt
        mv /raw-data/3.DADOS/microdados_enade_2019.txt /raw-data/microdados_enade_2019.txt
        if [ $? -eq 0 ]; then
            echo "Put file done"
            echo "Deleting raw data for enade"
            for i in `seq 1 3`;
            do
            rm -rf /raw-data/$i.*
            echo "/raw-data/$i.* deleted"
            done
    
        else
            echo "We have a problem putting $EXTRACTED_FILE on hdfs"
        fi
    else
        echo "$EXTRACTED_FILE does not exist."
    fi

else 
    echo "$FILE does not exist."
fi