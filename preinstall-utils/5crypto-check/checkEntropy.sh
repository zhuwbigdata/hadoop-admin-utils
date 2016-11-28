#!/bin/bash
for i in {1..3}; do  sleep 5; cat  /proc/sys/kernel/random/entropy_avail; done
