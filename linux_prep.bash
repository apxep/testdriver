#!/bin/bash
sudo dnf install -y iscsi-initiator-utils device-mapper-multipath git
sudo systemctl enable --now iscsid
sudo mpathconf --enable
sudo systemctl enable --now multipathd

sudo dnf install -y python3-pip python3-setuptools epel-release
#sudo dnf install -y ansible ansible-core # EPEL versions are old, use PIP
pip install ansible ansible-core
pip install pip setuptools --upgrade
pip install purestorage py-pure-client
pip install "pypsrp<=1.0.0"  # for psrp
pip install "pywinrm>=0.4.0"  # for winrm
