#!/bin/bash
echo "Swappiness should be set to 1 (range in  1-10)"
sudo sysctl -w vm.swappiness=1
