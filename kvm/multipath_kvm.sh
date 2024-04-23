fallocate -l 20G image.img
kvm -m 2048 -boot d -cdrom ./noble-live-server-amd64.iso \
    -device virtio-scsi-pci,id=scsi \
    -drive file=image.img,if=none,id=sda,format=raw,file.locking=off \
    -device scsi-hd,drive=sda,serial=0001 \
    -drive if=none,id=sdb,file=image.img,format=raw,file.locking=off \
    -device scsi-hd,drive=sdb,serial=0001
