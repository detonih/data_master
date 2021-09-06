import pymongo_spark
from pyspark.sql import SparkSession
import os

pymongo_spark.activate()

MONGO_CONN_STRING = os.getenv('MONGO_CONN_STRING')

spark = SparkSession.builder \
                    .appName("pyspark-mongo") \
                    .enableHiveSupport() \
                    .getOrCreate()

sql = """
SELECT * FROM enade.enade_tratado limit 1000
"""
df = spark.sql(sql)

rdd = df.rdd.map(tuple)

rdd.saveToMongoDB(MONGO_CONN_STRING + '/admin.enade')

spark.stop()