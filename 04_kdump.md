

#  Day-3, 세션 4 - Kdump #

### 시간이 오래 걸리는 아래 작업부터 실행 한다. ###
`yum --enablerepo=base-debuginfo install –y kernel-debuginfo-$(uname -r)`


## KDUMP 개요 ##
- kernel에 문제가 발생했을 경우, 상태를 확인해야함
- kernel이 정지하거나 Rebooting이 되면, 상태확인 하기 전에 정보가 휘발 됨
- 상태를 기록해야할 필요 有
- 평상시에 메모리에 상주하는 Dump용 커널을 적재
~~~
[root@clu_1 ~]# cat /proc/iomem | grep kernel
  2a000000-340fffff : Crash kernel
~~~
- Crash 발생 (panic sig, sysrq sig, oom killer sig 등)에 의하여, RIP 점프 to CrashKernel Pointer
  + /proc/vmcore ==> dd, ram capture, Storage dump 등
  + dump level에 따라서 덤프장치를 결정

### /etc/kdump.conf ###
- KDump 설정은 `/etc/kdump.conf` : https://github.com/windflex-sjlee/linux_troubleshooting/blob/master/conf/kdump.conf
~~~
path /var/crash
core_collector makedumpfile -l --message-level 1 -d 31
~~~
- `dump-level : 0~31` , `message-level : 0~31` (0에 가까울 수록 Full Dump )

~~~
net nfs.example.com:/export/vmcores : NFS
net kdump@crash.example.com  : SSH/SCP - 해당서버의 /var/crash에 저장 
~~~
- 위와 같이 원격지 (NFS, SSH) 설정 가능
  (Client에서 해당 mount에 쓰기권한 필요 ) 


### Kernel Dump가 필요한 경우 ###
1) Kernel Panic
2) OOM Killer 발생
3) Magic SysRQ (System Request)


## 잠깐 ##
[중요 용어]
- MCE ( Machine Check Exception )
- ACPI (Adavanced Configuration and Power Interface) 
- SMP (Symetric Multi Proccessor )


# KDUMP 구동 확인 #

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



### Crash 분석을 위한 kernel-debuginfo 패키지 설치 ###
```
yum --enablerepo=base-debuginfo install –y kernel-debuginfo-$(uname -r)
```
설치가 완료 되면, 아래 경로에서 vmlinux를 확보할 수 있다.
```
/usr/lib/debug/lib/modules/3.10.0-514.el7.x86_64/vmlinux
```

### 현재 사용하는 커널버전과 다른 커널을 설치할 경우, ###
```
yum --enablerepo=base-debuginfo install –y kernel-debuginfo-<커널버전>
```
```
/usr/lib/debug/lib/modules/<커널버전>
```

## kdump 구동 확인 ##

- `systemctl start kdump`
- `systemctl status kdump`
~~~
[root@clu_1 ~]# systemctl status kdump
● kdump.service - Crash recovery kernel arming
   Loaded: loaded (/usr/lib/systemd/system/kdump.service; enabled; vendor preset: enabled)
   Active: active (exited) since Thu 2018-12-06 19:28:23 KST; 1h 49min ago
~~~

- `cat /proc/cmdline`
~~~
[root@clu_1 ~]# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-3.10.0-514.el7.x86_64 root=/dev/mapper/cl-root ro crashkernel=auto rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet LANG=ko_KR.UTF-8
~~~


## booting 시 자동 시작하도록 설정 ##

- `systemctl enable kdump`
- `systemctl list-unit-files | grep kdump`
~~~
[root@clu_1 ~]# systemctl list-unit-files | grep kdump
kdump.service                                 enabled
~~~


## Grub 설정 확인 ##
- `grep crashkernel /etc/default/grub`
~~~
[root@clu_1 ~]# grep crashkernel /etc/default/grub
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet"
~~~

### /boot/grub/grub.conf 설명 ###
- `grep crashkernel /boot/grub2/grub.cfg`

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
- `/etc/default/grub` 파일을 변경후 리부팅

## kdump가 사용할 메모리 공간이 할당 되어 있는지 확인 ##
~~~
grep "kernel" /proc/iomem
sysctl -a | grep nmi_watchdog
 ==> 미설정 시, vi /etc/sysctl.conf 에서 kernel.nmi_watchdog =1
 ==> or echo 1 > 
~~~
- 혹은, `cat /proc/iomem | grep kernel`

~~~
[appadmin@clu_2 ~]$ sysctl -a | grep nmi_watchdog
kernel.nmi_watchdog = 1
~~~

## SysRQ ##
~~~
[appadmin@clu_2 ~]$ sysctl -a | grep sysrq
kernel.sysrq = 16
sysctl -w kernel.sysrq=1
~~~
- `sysctl -w kernel.sysrq=1` 대신 직접 메모리에 쓰는  `echo 1 > /proc/sys/kernel/sysrq` 동일 효과
- 위는 SysRQ의 직접적인 키보드 입력을 세팅하는 것임, 기본적으로 Disabled 이며, rebooting하면 초기화됨

### SysRQ 시그널 입력 ###
`echo c > /proc/sysrq-trigger`
* rebooting 됨 


## vmcore 파일 위치 ##
- `/etc/kdump.conf`의 설정에 따라서 /var/crash에 vmcore가 저장된다. 
- 경우에 따라서 경로확보가 안되는 경우가 있으나, vmcore파일을 찾아 본다.
- `find / -name vmcore`
~~~
[root@clu_1 ~]# find / -name vmcore
find: ‘/run/user/1000/gvfs’: Permission denied
/root/vmcore
/root/vmcore/504vmcore/vmcore
/var/spool/abrt/vmcore-127.0.0.1-2018-09-27-15:13:14/vmcore
/var/crash/127.0.0.1-2018-09-27-15:13:14/vmcore
/var/crash/127.0.0.1-2018-12-06-22:02:37/vmcore
~~~

- 기왕 찾은 김에, vmlinux 파일도 찾아 보자.
~~~
[root@clu_1 ~]# find / -name vmlinux
find: ‘/run/user/1000/gvfs’: Permission denied
/root/vmcore/2.6.32-504.el6.x86_64/vmlinux
/root/vmcore/3.10.0-514.el7.x86_64/vmlinux
/root/vmcore/3.10.0-862.11.6.el7.x86_64/vmlinux
/usr/lib/debug/usr/lib/modules/3.10.0-514.el7.x86_64/vmlinux
~~~

# CRASH 분석 #
- kdump는 kernel의 이상현상 발생 시, 그 시점에 상태(vmcore)를 저장하는 것이다. 
- 이상발생 시점이 저장되었으며, 이제 저장된 상태를 분석해야 한다. 
- vmcore가 정상적으로 dump 되었을 경우, crash 명령어를 통하여 분석할 수 있다.

* vmcore file 은 `/var/crash/<host-ip>-<date>` 형태의 위치에 저장된다. 이때 date는 hardware clock인데,
  때때로, virtualbox에서 hardware clock 동기화가 되지 않을 경우가 있다. 
  이 경우, `hwclock -w` 를 통해서 동기화 할 수 있다.

### CRASH 명령어 ###
- `crash <vmlinux> <vmcore>`
~~~
[root@clu_1 ~]# rpm -q --list kernel-debuginfo | grep vmlinux
[root@clu_1 ~]# crash /usr/lib/debug/usr/lib/modules/3.10.0-514.el7.x86_64/vmlinux /var/crash/127.0.0.1-2018-12-06-22\:02\:37/vmcore
~~~

- crash 분석 초기 화면의 예
~~~
 KERNEL: /usr/lib/debug/usr/lib/modules/3.10.0-514.el7.x86_64/vmlinux
    DUMPFILE: /var/crash/127.0.0.1-2018-12-06-22:02:37/vmcore  [PARTIAL DUMP]
        CPUS: 2
        DATE: Thu Dec  6 22:02:50 2018
      UPTIME: 02:35:04
LOAD AVERAGE: 0.00, 0.01, 0.05
       TASKS: 375
    NODENAME: clu_1
     RELEASE: 3.10.0-514.el7.x86_64
     VERSION: #1 SMP Tue Nov 22 16:42:41 UTC 2016
     MACHINE: x86_64  (2394 Mhz)
      MEMORY: 2 GB
       PANIC: "SysRq : Trigger a crash"
         PID: 5437
     COMMAND: "bash"
        TASK: ffff88004e8d8000  [THREAD_INFO: ffff880019518000]
         CPU: 1
       STATE: TASK_RUNNING (SYSRQ)
~~~



~~~
sys
bt
disas sysrq_handle_crash+22
disas /m sysrq_handle_crash+22
disas -l sysrq_handle_crash+22
vi /usr/src/debug/kernel-3.10.0-514.el7/linux-3.10.0-514.el7.x86_64/drivers/tty/sysrq.c
ps
kmem -i
~~~

### backtrace ###
~~~
crash> bt
PID: 5437   TASK: ffff88004e8d8000  CPU: 1   COMMAND: "bash"
 #0 [ffff88001951bb10] machine_kexec at ffffffff81059cdb
 #1 [ffff88001951bb70] __crash_kexec at ffffffff81105182
 #2 [ffff88001951bc40] crash_kexec at ffffffff81105270
 #3 [ffff88001951bc58] oops_end at ffffffff8168ee88
 #4 [ffff88001951bc80] no_context at ffffffff8167ea93
 #5 [ffff88001951bcd0] __bad_area_nosemaphore at ffffffff8167eb29
 #6 [ffff88001951bd18] bad_area at ffffffff8167ee4d
 #7 [ffff88001951bd40] __do_page_fault at ffffffff81691d1f
 #8 [ffff88001951bda0] do_page_fault at ffffffff81691dc5
 #9 [ffff88001951bdd0] page_fault at ffffffff8168e088
    [exception RIP: sysrq_handle_crash+22]
    RIP: ffffffff813ed516  RSP: ffff88001951be88  RFLAGS: 00010246
    RAX: 000000000000000f  RBX: ffffffff81a7bfe0  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: ffff88007fd0f838  RDI: 0000000000000063
    RBP: ffff88001951be88   R8: 0000000000000086   R9: 0000000000000211
    R10: 0000000000000210  R11: 0000000000000003  R12: 0000000000000063
    R13: 0000000000000000  R14: 0000000000000004  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
#10 [ffff88001951be90] __handle_sysrq at ffffffff813edd37
~~~

### disas sysrq_handle_crash+22 ###
~~~
crash> disas sysrq_handle_crash+22
Dump of assembler code for function sysrq_handle_crash:
   0xffffffff813ed500 <+0>:     nopl   0x0(%rax,%rax,1)
   0xffffffff813ed505 <+5>:     push   %rbp
   0xffffffff813ed506 <+6>:     mov    %rsp,%rbp
   0xffffffff813ed509 <+9>:     movl   $0x1,0x5fe341(%rip)        # 0xffffffff819eb854 <panic_on_oops>
   0xffffffff813ed513 <+19>:    sfence
   0xffffffff813ed516 <+22>:    movb   $0x1,0x0
   0xffffffff813ed51e <+30>:    pop    %rbp
   0xffffffff813ed51f <+31>:    retq
End of assembler dump.
~~~

### disas /m sysrq_handle_crash+22 ###
~~~
crash> disas /m sysrq_handle_crash+22
Dump of assembler code for function sysrq_handle_crash:
134     {
   0xffffffff813ed500 <+0>:     nopl   0x0(%rax,%rax,1)
   0xffffffff813ed505 <+5>:     push   %rbp
   0xffffffff813ed506 <+6>:     mov    %rsp,%rbp

135             char *killer = NULL;
136
137             /* we need to release the RCU read lock here,
138              * otherwise we get an annoying
139              * 'BUG: sleeping function called from invalid context'
140              * complaint from the kernel before the panic.
141              */
142             rcu_read_unlock();
143             panic_on_oops = 1;      /* force panic */
   0xffffffff813ed509 <+9>:     movl   $0x1,0x5fe341(%rip)        # 0xffffffff819eb854 <panic_on_oops>

144             wmb();
   0xffffffff813ed513 <+19>:    sfence

145             *killer = 1;
   0xffffffff813ed516 <+22>:    movb   $0x1,0x0
~~~

### ps ###
~~~
crash> ps
   PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
>     0      0   0  ffffffff819c1460  RU   0.0       0      0  [swapper/0]
      0      0   1  ffff88007c061f60  RU   0.0       0      0  [swapper/1]
      1      0   0  ffff88007c7b0000  IN   0.2  125456   3820  systemd
      2      0   1  ffff88007c7b0fb0  IN   0.0       0      0  [kthreadd]
      3      2   0  ffff88007c7b1f60  IN   0.0       0      0  [ksoftirqd/0]
      5      2   0  ffff88007c7b3ec0  IN   0.0       0      0  [kworker/0:0H]
      7      2   0  ffff88007c7b5e20  IN   0.0       0      0  [migration/0]
      8      2   0  ffff88007c7b6dd0  IN   0.0       0      0  [rcu_bh]
      9      2   1  ffff88007c060000  IN   0.0       0      0  [rcu_sched]
~~~

# Kernel Module #

### kernel module을 이용한 Kernel Crash 및 분석 ###
- 커널모듈 install source
https://github.com/windflex-sjlee/linux_kernel_module/blob/master/README.md

- [커널 모듈 분석]
https://github.com/windflex-sjlee/linux_troubleshooting/blob/master/linux_kernel_module.md

```bash
$ wget https://raw.githubusercontent.com/windflex-sjlee/linux_kernel_module/master/start_kernel_crash.sh
$ chmod u+x start_kernel_crash.sh
$ ./start_kernel_crash.sh
```











