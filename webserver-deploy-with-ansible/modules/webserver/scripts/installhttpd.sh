#!/bin/bash
sudo aws s3 cp s3://dpt4-web-data/webserver.zip  /tmp/webserver.zip
sudo gunzip /tmp/webserver.zip
sudo ansible-playbook /tmp/webserver.yaml