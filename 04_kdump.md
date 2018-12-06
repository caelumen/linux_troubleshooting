

======
#  Kdump

## kdump 패키지 확인 ##
<pre>

rpm - qa | grep kexec-tools
</pre>

## kernel-debuginfo 설치 ##
<pre>

yum --enablerepo=base-debuginfo install –y kernel-debuginfo-$(uname -r)
 (※ yum install kernel-debuginfo )
 (※ kernel-debuginfo 에는 kernel debug 관련 소스파일, vmlinux 파일 등 포함)
</pre>


## kdump 구동 확인 ##
<pre>

systemctl status kdump
systemctl start kdump
cat /proc/cmdline
</pre>

## booting 시 자동 시작하도록 설정 ##
<pre>

systemctl enable kdump
systemctl list-unit-files | grep kdump

</pre>

## Grub 설정 확인 ##
<pre>

grep crashkernel /etc/default/grub
grep crashkernel /boot/grub2/grub.cfg
</pre>

## grub 설정이 안되어 있으면,##
## /etc/default/grub 파일을 변경후 리부팅##

## kdump가 사용할 메모리 공간이 할당 되어 있는지 확인 ##
<pre>

grep "kernel" /proc/iomem

sysctl -a | grep nmi_watchdog
 ==> 미설정 시, vi /etc/sysctl.conf 에서 kernel.nmi_watchdog =1
 ==> or echo 1 > 
</pre>



## SysRQ ##
<pre>
sysctl -a | grep sysrq
sysctl -w kernel.sysrq=1      or      echo 1 > /proc/sys/kernel/sysrq
echo c > /proc/sysrq-trigger
</pre>

## rebooting 됨 ##


## vmcore 파일 위치 ##
<pre>
find / -name vmcore 
 ==> /var/crash/ ...
</pre>

## vmcore 파일 위치 ##
 - /var/crash/ ...
 - /etc/kdump.conf 에서 변경 가능

## crash 분석 ##
<pre>
crash <vmlinux> <vmcore>
</pre>

<pre>
rpm -q --list kernel-debuginfo | grep vmlinux
crash /usr/lib/debug/lib/modules/3.10.0-514.el7.x86_64/vmlinux /var/crash/127.0.0.1-2018-09-27-15\:13\:14/vmcore
</pre>

<pre>
bt
disas sysrq_handle_crash+22
disas -l sysrq_handle_crash+22
vi /usr/src/debug/kernel-3.10.0-514.el7/linux-3.10.0-514.el7.x86_64/drivers/tty/sysrq.c

</pre>

## <lab> ##
<pre>
vmcore
https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmcore
</pre>
 
<pre> 
vmlinux
https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmlinux
</pre>

<pre>
sys
kmem -i
ps
ps | grep -c RU
sys | grep LOAD
ps | wc -l
ps | grep -c httpd
ps | grep -c java
</pre>






