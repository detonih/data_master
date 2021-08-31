#!/bin/bash

spark-submit \
--master local[*] \
--deploy-mode client \
--jars /tmp/mongo-hadoop-spark-2.0.2.jar \
--driver-class-path /tmp/mongo-hadoop-spark-2.0.2.jar \
--py-files /tmp/mongo-hadoop/spark/src/main/python/pymongo_spark.py,/usr/local/lib/python3.6/dist-packages/pymongo_spark-0.1.dev0-py3.6.egg \
/scripts/python/pyspark_mongo.py

