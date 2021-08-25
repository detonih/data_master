from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("teste").getOrCreate()

df = spark.read \
          .option("header", "true") \
          .option("delimiter",";")\
          .option("inferSchema", "true") \
          .csv("/stage/microdados_enade_2019.txt")

df.show()