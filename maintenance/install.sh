#!/bin/bash
python3 -m venv .venv
source .venv/bin/activate
pip3 install -r requirements.txt
mv contrib/*.{service,timer} /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now maintenance-optimize-rds.timer
