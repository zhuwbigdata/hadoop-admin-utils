# use sql context 
import sys
from pyspark import SparkContext 
from pyspark.sql import HiveContext, Row 
sc = SparkContext(appName="PySelectDP1")
sqlCtx = HiveContext(sc)
cnt_orc = sqlCtx.sql("SELECT COUNT(*) FROM bible.orc_part1_book")
chapter = sqlCtx.sql("SELECT verse FROM bible.orc_part1_book WHERE cidx = 3  AND  book = 'Jn'")
verse = sqlCtx.sql("SELECT verse FROM bible.orc_part1_book WHERE cidx = 3 AND vidx = 16  AND  book = 'Jn'")
verse_cnt = sqlCtx.sql("SELECT COUNT(distinct(cidx)) FROM bible.orc_part1_book WHERE book = 'Jn'")
chapter_verse_cnt = sqlCtx.sql("SELECT cidx, COUNT(vidx) FROM bible.orc_part1_book WHERE book = 'Jn' GROUP BY cidx")
print cnt_orc.collect()
print chapter.collect()
print verse.collect()
print verse_cnt.collect()
print chapter_verse_cnt.collect()

