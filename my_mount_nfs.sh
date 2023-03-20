#!/bin/bash

sudo mkdir -p /mnt/smbsharedataset
sudo mount -v -t cifs //truenas.localdomain/smbsharedataset /mnt/smbsharedataset -o user=mitch
