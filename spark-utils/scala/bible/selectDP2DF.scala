/* use sql context */
import org.apache.spark.sql._
val sqlCtx = new org.apache.spark.sql.hive.HiveContext(sc)
val book_df  = sqlCtx.sql("SELECT * FROM bible.orc_part1_book WHERE book = 'Jn'")
val verse316_df = book_df.filter("cidx = 3").where("vidx = 16")
val verse_df = verse316_df.select("verse")
verse_df.collect().foreach(println)

