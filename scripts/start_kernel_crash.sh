#!/bin/bash

#yum install git -y
#git clone https://github.com/windflex-sjlee/linux_kernel_module.git
#linux_kernel_module/install.sh
#linux_kernel_module/fault.sh

yum install git -y
git clone https://github.com/windflex-sjlee/linux_kernel_module.git
linux_kernel_module/install.sh

while true; do
    read -p "Do you want to make a kernel crash intentionally ? [y/n] " yn
    case $yn in
        [Yy]* ) echo " => Starting Kernel Crashing .... !!"; linux_kernel_module/fault.sh; break;;
        [Nn]* ) echo " => Stopping Kernel Crashing .... !!"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

