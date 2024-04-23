CLOUD_IMAGE_FILENAME="noble-server-cloudimg-amd64.img"
qemu-img create \
    	-F qcow2 -b ${CLOUD_IMAGE_FILENAME} \
    	-f qcow2 ${CLOUD_IMAGE_FILENAME}.qcow2 10G
cat > user-data <<EOF
#cloud-config
hostname: test-vm
users:
  - default
  - name: ubuntu
    passwd: "password"
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvAoJnKjo/UQZy/LFKiv8SiXQ6CiX9ichg+LM275/893gOgpaw1w9Jc3i9tkKRDN5bfCq97GAO0CX40gTAGkl3ES6F9gEeoe71eFImn7dXGDMzqYcpPDkRU789KDV0YONEFM/UvOH5KADzkX+EdMFRLBzMEWC7nBl97+5Pc2Hnn03TVpCl9OYvyQx1RS9IZpO2ctrhTuLGmo3oWk5FwDUilzn7CpJfAkxJB9gA0LVIFXhApEVsRpNsKrlC0gJWPPA6r4goPMWgGTbZuIHxmhZqqN3OdCbcPkcA+pDdLfKNuF3LDKo203lJXNRYZmTvroz6og+55dhIH8VF9o1vnnhL81/1ZIixdVV3Wm4xN+be2RvL/RtCwCRHT4Lj9NFQV4WnnNriKIwAACE8o2LQRaveOmbXdwM92n19ORBFBQa5MhdBDZedrtutyINDjRvMo6DIHtT3YvFaUM9sF+vFnucvwmmU/BOKJ13gYtyDw9EB114kWMhe/6218B/v6dWoj4s= mitch@light
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
runcmd:
  - echo "AllowUsers ubuntu" >> /etc/ssh/sshd_config
  - systemctl restart ssh

EOF
echo "instance-id: $(uuidgen || echo i-abcdefg)" > meta-data

# Create seed disk
cloud-localds --verbose \
	"${CLOUD_IMAGE_FILENAME}"-seed.qcow2 \
	user-data \
	meta-data

# Create storage disk
qemu-img create -f qcow2 "${CLOUD_IMAGE_FILENAME}"-storage.qcow2 1G

NETWORK="test-network"
# Create virsh network
cat > "$NETWORK".xml <<EOF
<network>
  <name>${NETWORK}</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='${NETWORK}' stp='on' delay='0'/>
  <ip address='192.168.30.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.30.2' end='192.168.30.254'/>
    </dhcp>
  </ip>
</network>
EOF
virsh net-define "$NETWORK".xml
virsh net-start "$NETWORK"

VM_NAME="test"
RAM="2048"
VCPU=4
# Install the image
sudo virt-install \
  	--virt-type kvm \
	--name "${VM_NAME}" \
  	--ram ${RAM} \
  	--vcpus=${VCPU} \
	--os-variant ubuntu18.04 \
	--disk path="${CLOUD_IMAGE_FILENAME}".qcow2,device=disk \
	--disk path="${CLOUD_IMAGE_FILENAME}"-seed.qcow2,device=disk \
	--disk path="${CLOUD_IMAGE_FILENAME}"-storage.qcow2,device=disk \
  	--import \
  	--network network=default,model=virtio \
  	--noautoconsole

