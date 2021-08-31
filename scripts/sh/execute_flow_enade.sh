#!/bin/bash

echo "Getting data from enade..."
bash -x /scripts/sh/get_enade.sh

if [ $? -eq 0 ]; then
    echo "Get enade data successfully"
    echo "Loading data into MySQL database..."

    python3 /scripts/python/enade_pandas.py

    if [ $? -eq 0 ]; then
        echo "Data loaded into MySQL database successfully"
        echo "Creating database enade on Hive..."
        hive -e "CREATE DATABASE enade;"

        if [ $? -eq 0 ]; then
          echo "enade database created successfully on Hive"
          echo "Trying to import enade data from MySQL database to hive table..."

          sqoop import --connect jdbc:mysql://172.21.0.1:3306/enade \
          --driver com.mysql.cj.jdbc.Driver \
          --username root \
          --password ${MYSQL_ROOT_PASSWORD} \
          --split-by id \
          --columns id,NU_IDADE,SEXO,RENDA_FAMILIAR,COR,TP_ESCOLA \
          --table enade_tratado \
          --bindir /tmp/sqoop-root/compile \
          --target-dir /user/root/enade_tratado  \
          --fields-terminated-by ","  \
          --hive-import \
          --create-hive-table \
          --hive-table enade.enade_tratado
          
          if [ $? -eq 0 ]; then
            echo "Import data from MySQL successfully"

          else
              echo "We have a problem importing data from MySQL database"
              exit 1
          fi
        
        else
            echo "We have a problem creating enade database on Hive"
            exit 1
        fi
    else
        echo "We have a problem loading data into MySQL database"
        exit 1
    fi
else
    echo "We have a problem getting enade data"
    exit 1
fi



