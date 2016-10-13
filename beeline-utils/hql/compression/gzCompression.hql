SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.GZipCodec;
SET mapred.output.compression.type=BLOCK;
USE default;
CREATE TABLE IF NOT EXISTS gzcompressiontest (a int);
INSERT INTO  gzcompressiontest VALUES (1);
DROP TABLE IF EXISTS gzcompressiontest;

