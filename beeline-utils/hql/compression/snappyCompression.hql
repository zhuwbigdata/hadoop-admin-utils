SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
SET mapred.output.compression.type=BLOCK;
USE default;
CREATE TABLE IF NOT EXISTS snappycompressiontest (a int);
INSERT INTO  snappycompressiontest VALUES (1);
DROP TABLE IF EXISTS snappycompressiontest;

