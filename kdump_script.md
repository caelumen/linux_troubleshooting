[ GDB ]

sudo yum update -y
sudo yum install -y kexec-tools kernel-debuginfo crash



sudo systemctl start kdump
sudo systemctl status kdump
sudo systemctl enable kdump
systemctl list-unit-files | grep kdump


### when Not config ###

rpm -qa kexec-tools
sudo systemctl status kdump
cat /proc/cmdline 

sudo vi /etc/default/grub
cat /boot/grub2/grub.cfg
sudo cat /boot/grub2/grub.cfg
sudo cat /boot/grub2/grub.cfg | grep kernel
sudo vi /boot//grub2/grub.cfg
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

reboot

### End of  Not config ###




sudo cat /proc/iomem | grep kernel
sudo sysctl -a | grep nmi_watchdog

sudo su

sysctl -w kernel.nmi_watchdog=1
echo 1 > /proc/sys/kernel/sysrq
echo c > /proc/sysrq-trigger

# reboot µ» ¥Ÿ¿Ω 

ls -al /var/crash





