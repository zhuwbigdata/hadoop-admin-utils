/* use sql context */
import org.apache.spark.sql._
val sqlCtx = new org.apache.spark.sql.hive.HiveContext(sc)
val cnt_orc = sqlCtx.sql("SELECT COUNT(*) FROM bible.orc_part1_book")
val chapter = sqlCtx.sql("SELECT verse FROM bible.orc_part1_book WHERE cidx = 3  AND  book = 'Jn'")
val verse = sqlCtx.sql("SELECT verse FROM bible.orc_part1_book WHERE cidx = 3 AND vidx = 16  AND  book = 'Jn'")
val verse_cnt = sqlCtx.sql("SELECT COUNT(distinct(cidx)) FROM bible.orc_part1_book WHERE book = 'Jn'")
val chapter_verse_cnt = sqlCtx.sql("SELECT cidx, COUNT(vidx) FROM bible.orc_part1_book WHERE book = 'Jn' GROUP BY cidx")
cnt_orc.collect().foreach(println)
chapter.collect().foreach(println)
verse.collect().foreach(println)
verse_cnt.collect().foreach(println)
chapter_verse_cnt.collect().foreach(println)

