#!/bin/bash

IMAGE_NAME="jammy"

if [ $# -ge 1 ]; then
	IMAGE_NAME=$1
fi

autopkgtest-buildvm-ubuntu-cloud -r "${IMAGE_NAME}" -v --cloud-image-url http://cloud-images.ubuntu.com/daily/server
sudo mkdir -p /var/lib/adt-images/
sudo rm -f "/var/lib/adt-images/autopkgtest-${IMAGE_NAME}-amd64.img"
sudo mv "autopkgtest-${IMAGE_NAME}-amd64.img" /var/lib/adt-images/
