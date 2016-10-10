USE chicago;
CREATE EXTERNAL TABLE IF NOT EXISTS employeeSalariesAndTitles (lname STRING, fname STRING, title STRING, department STRING, salary DOUBLE) 
COMMENT 'CSV format'
ROW FORMAT DELIMITED  
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/${hiveconf:USER}/dfs/input/raw/chicago';

