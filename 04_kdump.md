

#  Day-3, 세션 4 - Kdump #

### 시간이 오래 걸리는 아래 작업부터 실행 한다. ###
`yum --enablerepo=base-debuginfo install –y kernel-debuginfo-$(uname -r)`


## KDUMP 개요 ##
- kernel에 문제가 발생했을 경우, 상태를 확인해야함
- kernel이 정지하거나 Rebooting이 되면, 상태확인 하기 전에 정보가 휘발 됨
- 상태를 기록해야할 필요 有

### Kernel Dump가 필요한 경우 ###
1) Kernel Panic
2) OOM Killer 발생
3) Magic SysRQ (System Request)


## kdump 패키지 확인 ##
- 패키지 설치 확인
` [root@clu_1 ~]# rpm -q kexec-tools ` or `rpm - qa | grep kexec-tools`

- 만약 설치 되어 있지 않다면,
~~~
# yum install kexec-tools
# yum install kernel-kdump
~~~


## kernel-debuginfo 설치 ##
<pre>
yum --enablerepo=base-debuginfo install –y kernel-debuginfo-$(uname -r)
 (※ yum install kernel-debuginfo )
 (※ kernel-debuginfo 에는 kernel debug 관련 소스파일, vmlinux 파일 등 포함)
</pre>


## kdump 구동 확인 ##
~~~
systemctl status kdump
systemctl start kdump
cat /proc/cmdline
~~~


## booting 시 자동 시작하도록 설정 ##
~~~
systemctl enable kdump
systemctl list-unit-files | grep kdump
~~~


## Grub 설정 확인 ##
~~~
grep crashkernel /etc/default/grub
grep crashkernel /boot/grub2/grub.cfg
~~~


### /boot/grub/grub.conf 설명 ###
~~~
### BEGIN /etc/grub.d/10_linux ###
menuentry 'CentOS Linux (3.10.0-514.el7.x86_64) 7 (Core)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-3.10.0-514.el7.x86_64-advanced-b587c2f3-973b-466b-bbe1-dfdcae0bb792' {
        load_video
        set gfxpayload=keep
        insmod gzio
        insmod part_msdos
        insmod xfs
        set root='hd0,msdos1'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 --hint='hd0,msdos1'  5acf284e-58fa-4819-8cd9-fcd0152dcde0
        else
          search --no-floppy --fs-uuid --set=root 5acf284e-58fa-4819-8cd9-fcd0152dcde0
        fi
        linux16 /vmlinuz-3.10.0-514.el7.x86_64 root=/dev/mapper/cl-root ro crashkernel=auto rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet LANG=ko_KR.UTF-8
        initrd16 /initramfs-3.10.0-514.el7.x86_64.img
}
~~~~
- crashkernel 매개 변수 를 확인할 것
- `crashkernel=auto`  or `crashkernel=128M` 



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






