USE  bible;
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.error.on.empty.partition=true;
set mapreduce.map.memory.mb=2048;
set mapreduce.map.java.opts=-Xmx3686m;
INSERT OVERWRITE TABLE orc_part2_book_chapter
PARTITION (book, chNbr)
SELECT *, bookname, cidx FROM orc;
#ANALYZE TABLE orc_part_book_chapter PARTITION (book, chNbr) COMPUTE STATISTICS;
#SELECT COUNT(*) FROM orc_part2_book_chapter;
!quit
