SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.BZip2Codec;
SET mapred.output.compression.type=BLOCK;
USE default;
CREATE TABLE IF NOT EXISTS bzip2compressiontest (a int);
INSERT INTO  bzip2compressiontest VALUES (1);
DROP TABLE IF EXISTS bzip2compressiontest;

