
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
Run this command at the root of your directory to build against the chroot:
```
sbuild -s --force-orig-source -c mantic -d mantic
```
To log in to the schroot to update `/etc/apt/sources.list` or other files:
```
schroot -c mantic -u root
```
