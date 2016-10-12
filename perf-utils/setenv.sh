#!/bin/bash
MR_EXAMPLE_JAR_LOC=/usr/lib/hadoop-0.20-mapreduce/hadoop-examples.jar
DFS_BLOCK_SZ=$(hdfs getconf -confKey dfs.blocksize) 
export MR_EXAMPLE_JAR_LOC
export DFS_BLOCK_SZ
