USE  bible;
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.error.on.empty.partition=true;
set mapreduce.map.memory.mb=2048;
set mapreduce.map.java.opts=-Xmx1986m;
INSERT OVERWRITE TABLE orc_part1_book
PARTITION (book)
SELECT *, bookname FROM orc;
SHOW PARTITIONS orc_part1_book;
ANALYZE TABLE orc_part1_book PARTITION (book) COMPUTE STATISTICS;
SELECT COUNT(*) FROM orc;
SELECT COUNT(*) FROM orc_part1_book;
!quit
