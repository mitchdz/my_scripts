#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

DATE=$(date +%Y%m%d)

HOME_DIR="/home/${SUDO_USER}"
BAK_DIR="${HOME_DIR}/${DATE}-light-bak"

mkdir -p ${BAK_DIR}
cp -r ${HOME_DIR}/.aws/ ${BAK_DIR}/aws/
cp -r ${HOME_DIR}/keys/ ${BAK_DIR}/
cp -r ${HOME_DIR}/.ssh/ ${BAK_DIR}/ssh/
cp -r ${HOME_DIR}/.config/ ${BAK_DIR}/config/
cp -r /etc/ ${BAK_DIR}/etc/
cp ${HOME_DIR}/snap/chromium/common/chromium/Default/Bookmarks ${BAK_DIR}/
history > ${BAK_DIR}/history.txt

tar -cvzf ${BAK_DIR}.tar.gz ${BAK_DIR}

