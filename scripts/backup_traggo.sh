#!/bin/bash
eval `ssh-agent -s`
ssh-add ~/keys/linuxkey.pem
scp ubuntu@1.2.3.4:/opt/traggo/data/traggo.db ~/traggo/traggo.db

