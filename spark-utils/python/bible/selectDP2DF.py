# use sql context 
import sys
from pyspark import SparkContext 
from pyspark.sql import HiveContext, Row 
sc = SparkContext(appName="PySelectDP2")
sqlCtx = HiveContext(sc)
book_df = sqlCtx.sql("SELECT * FROM bible.orc_part1_book WHERE book = 'Jn'")
verse_df = book_df.where("cidx = 3 and vidx = 16").select("verse")
print verse_df.collect()

