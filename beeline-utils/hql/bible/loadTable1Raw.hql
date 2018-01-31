USE bible;
-- LEB.txt owned by user  in CDH (doas=true), hive in HDP (doas=false)
LOAD DATA INPATH '/tmp/LEB.txt' OVERWRITE INTO TABLE raw;
SELECT COUNT(*) FROM raw;
!quit
