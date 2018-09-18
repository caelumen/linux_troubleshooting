# [ Kdump 진행과정 ]

# 관련 패키지가 설치되어 있는지 확인
<pre>
sudo yum update -y
sudo yum install -y kexec-tools kernel-debuginfo crash
</pre>

# Kdump의 상태를 확인, 서비스 기동
<pre>
sudo systemctl start kdump
sudo systemctl status kdump
sudo systemctl enable kdump
systemctl list-unit-files | grep kdump
cat /proc/iomem | grep kernel
</pre>

# kdump 서비스가 올라와 있지 않는 경우

<pre>
rpm -qa kexec-tools
sudo systemctl status kdump
cat /proc/cmdline 

sudo vi /etc/default/grub
cat /boot/grub2/grub.cfg
sudo cat /boot/grub2/grub.cfg
sudo cat /boot/grub2/grub.cfg | grep kernel
sudo vi /boot//grub2/grub.cfg
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
</pre>

## 설정이 끝나면 리부팅 해주어야 한다.
<pre>
reboot
</pre>

# 마지막 메모리 확인, 커널 파라미터 확인
<pre>
sudo cat /proc/iomem | grep kernel
sudo sysctl -a | grep nmi_watchdog
sudo sysctl -w kernel.nmi_watchdog=1
</pre>

# 자! 이제 (의도적) 크래쉬를 발생 시킨다.
<pre>
sudo su -

echo 1 > /proc/sys/kernel/sysrq
echo c > /proc/sysrq-trigger
</pre>

# 리부팅 된 후, /var/crash에서 dump파일 확인 
<pre>
ls -al /var/crash
</pre>




