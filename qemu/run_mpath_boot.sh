#!/bin/bash

# This offers a guide to test multipath-tools-boot in an interactive env

# wget https://cloud-images.ubuntu.com/minimal/daily/oracular/20240626/oracular-minimal-cloudimg-amd64.img

ubuntu_image="oracular-server-cloudimg-amd64.img"

# create cloudinit seed
cat > metadata.yaml <<EOF
instance-id: iid-local01
local-hostname: cloudimg
EOF

cat > user-data.yaml <<EOF
#cloud-config
users:
  - name: ubuntu
    ssh_pwauth: true
    passwd: test
    lock_passwd: false
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash

chpasswd:
  list: |
    ubuntu:test
  expire: False

ssh_pwauth: true
EOF

cloud-localds seed.img user-data.yaml metadata.yaml

qemu-system-x86_64  \
  -machine accel=kvm,type=q35 \
  -cpu host \
  -m 2G \
  -nographic \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-scsi-pci,id=scsi \
  -drive if=none,id=disk1a,format=qcow2,file="$ubuntu_image",cache=none,file.locking=off \
  -device scsi-hd,drive=disk1a,serial=abc,wwn=0x6001405cb35f25d7 \
  -drive if=none,id=disk1b,format=qcow2,file="$ubuntu_image",cache=none,file.locking=off \
  -device scsi-hd,drive=disk1b,serial=abc,wwn=0x6001405cb35f25d7 \
  -drive if=virtio,format=raw,file=seed.img

