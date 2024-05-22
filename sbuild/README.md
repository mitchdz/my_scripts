
```
sudo mkdir -p /etc/schroot/chroot.d/
sudo tee /etc/schroot/chroot.d/mantic.conf << EOM
[mantic]
description=Ubuntu Mantic
directory=/srv/mantic-chroot
root-users=mitch
type=directory
users=mitch
EOM
sudo debootstrap mantic /srv/mantic-chroot
```

