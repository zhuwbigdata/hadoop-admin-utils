#!/bin/bash
sudo sed -i -e 's/ExecStart=\/sbin\/rngd -f/ExecStart=\/sbin\/rngd -f -r \/dev\/urandom/' /etc/systemd/system/rngd.service
sudo systemctl daemon-reload
sudo systemctl start rngd
sudo systemctl enable rngd
