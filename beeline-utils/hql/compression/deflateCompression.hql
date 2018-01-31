SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.DefaultCodec;
SET mapred.output.compression.type=BLOCK;
USE default;
CREATE TABLE IF NOT EXISTS deflatecompressiontest (a int);
INSERT INTO  deflatecompressiontest VALUES (1);
DROP TABLE IF EXISTS deflatecompressiontest;

