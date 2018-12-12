#!/bin/bash

# kernel-header check or install  for kernel module compile
ll /usr/src/kernels/
yum install kernel-devel
ls -l /usr/src/kernels/$(uname -r)
yum install kernel-headers

# git install
yum install git -y
git clone https://github.com/windflex-sjlee/linux_kernel_module.git

# make install and insert kernel module
linux_kernel_module/install.sh

# executing fault.sh and ask if doing them or not
while true; do
    read -p "Do you want to make a kernel crash intentionally ? [y/n] " yn
    case $yn in
        [Yy]* ) echo " => Starting Kernel Crashing .... !!"; linux_kernel_module/fault.sh; break;;
        [Nn]* ) echo " => Stopping Kernel Crashing .... !!"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

