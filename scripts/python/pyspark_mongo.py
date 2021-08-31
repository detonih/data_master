import pymongo_spark
from pyspark import SparkContext, SparkConf
import os

pymongo_spark.activate()

MONGO_INITDB_ROOT_PASSWORD = os.getenv('MONGO_INITDB_ROOT_PASSWORD')

conf = SparkConf().setAppName("pyspark test")
sc = SparkContext(conf=conf)

rdd = sc.parallelize([1,2,3,4,5,6,7,8,9,10])

rdd.saveToMongoDB(f'mongodb://root:{MONGO_INITDB_ROOT_PASSWORD}@172.21.0.1:27017/admin.enade')
