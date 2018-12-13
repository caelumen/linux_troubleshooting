# SOS Report #

```bash
[root@clu_1 ~]# rpm -qa | grep sos
sos-3.3-4.el7.centos.noarch
[root@clu_1 ~]# which sosreport
/usr/sbin/sosreport
[root@clu_1 ~]# rpm -qf /usr/sbin/sosreport
sos-3.3-4.el7.centos.noarch
```

## SOSReport 실행 결과 ##
- 기본사용 : SOSReport 입력후 Default 설정 (연속 `<Enter>` 입력)
```bash
[root@clu_1 ~]# sosreport

sosreport (version 3.3)
This command will collect diagnostic and configuration information from
this CentOS Linux system and installed applications.

   [중       략 ]
The generated archive may contain data considered sensitive and its
content should be reviewed by the originating organization before being
passed to any third party.

No changes will be made to system configuration.

Press ENTER to continue, or CTRL-C to quit.
Please enter your first initial and last name [clu_1]:
Please enter the case id that you are generating this report for []:
```

## 수집 대상 지정 ##
- `-o` 옵션으로 수집 대상 지정
```bash
$ sosreport -o hardware -o kernel -o networking -o udev -o system -o rpm
```

- 시간이 많이 소요되는 RPM 정보 제외 
```
$ sosreport -k rpm.rpmva=off
```

## 저장된 SOSReport 파일 확인 ##

- SOSReport를 실행하고나면, 마지막에 위치를 확인할 수 있음
```bash
  [ 상위 생략 ]
Your sosreport has been generated and saved in:
  /var/tmp/sosreport-clu1-20181213112633.tar.xz
```

```bash
[root@clu_1 tmp]#
[root@clu_1 tmp]# cd /var/tmp
[root@clu_1 tmp]# ll
total 33292
drwxr-xr-x. 2 abrt abrt        6 Sep 27 15:02 abrt
-rw-------  1 root root 17036068 Dec 13 11:22 sosreport-clu1-20181213112010.tar.xz
-rw-r--r--  1 root root       33 Dec 13 11:22 sosreport-clu1-20181213112010.tar.xz.md5
-rw-------  1 root root 17040376 Dec 13 11:28 sosreport-clu1-20181213112633.tar.xz
-rw-r--r--  1 root root       33 Dec 13 11:28 sosreport-clu1-20181213112633.tar.xz.md5

[root@clu_1 tmp]# tar xvfp sosreport-clu1-20181213112633.tar.xz
[root@clu_1 tmp]# cd sosreport-clu1-20181213112633/
[root@clu_1 sosreport-clu1-20181213112633]# ll
total 16
dr-xr-xr-x  3 root root   19 Nov 27 15:51 boot
lrwxrwxrwx  1 root root   38 Dec 13 11:27 chkconfig -> sos_commands/services/chkconfig_--list
lrwxrwxrwx  1 root root   25 Dec 13 11:26 date -> sos_commands/general/date
lrwxrwxrwx  1 root root   27 Dec 13 11:26 df -> sos_commands/filesys/df_-al
lrwxrwxrwx  1 root root   31 Dec 13 11:26 dmidecode -> sos_commands/hardware/dmidecode
drwxr-xr-x 50 root root 4096 Dec 12 17:55 etc
lrwxrwxrwx  1 root root   24 Dec 13 11:26 free -> sos_commands/memory/free
lrwxrwxrwx  1 root root   29 Dec 13 11:26 hostname -> sos_commands/general/hostname
lrwxrwxrwx  1 root root  130 Dec 13 11:27 installed-rpms -> sos_commands/rpm/sh_-c_rpm_--nodigest_-qa_--qf_NAME_-_VERSION_-_RELEASE_._ARCH_INSTALLTIME_date_awk_-F_printf_-59s_s_n_1_2_sort_-f
lrwxrwxrwx  1 root root   34 Dec 13 11:26 ip_addr -> sos_commands/networking/ip_-o_addr
lrwxrwxrwx  1 root root   45 Dec 13 11:26 java -> sos_commands/java/alternatives_--display_java
lrwxrwxrwx  1 root root   22 Dec 13 11:26 last -> sos_commands/last/last
dr-xr-xr-x  7 root root   78 Oct 19 09:29 lib
lrwxrwxrwx  1 root root   35 Dec 13 11:26 lsb-release -> sos_commands/lsbrelease/lsb_release
lrwxrwxrwx  1 root root   25 Dec 13 11:26 lsmod -> sos_commands/kernel/lsmod
lrwxrwxrwx  1 root root   36 Dec 13 11:27 lsof -> sos_commands/process/lsof_-b_M_-n_-l
lrwxrwxrwx  1 root root   28 Dec 13 11:27 lspci -> sos_commands/pci/lspci_-nnvv
lrwxrwxrwx  1 root root   29 Dec 13 11:26 mount -> sos_commands/filesys/mount_-l
lrwxrwxrwx  1 root root   41 Dec 13 11:26 netstat -> sos_commands/networking/netstat_-W_-neopa
dr-xr-xr-x 11 root root 4096 Dec 12 22:57 proc
lrwxrwxrwx  1 root root   30 Dec 13 11:27 ps -> sos_commands/process/ps_auxwww
lrwxrwxrwx  1 root root   27 Dec 13 11:27 pstree -> sos_commands/process/pstree
dr-xr-x---  2 root root   29 Dec 12 11:30 root
lrwxrwxrwx  1 root root   32 Dec 13 11:26 route -> sos_commands/networking/route_-n
drwx------ 69 root root 4096 Dec 13 11:28 sos_commands
drwx------  2 root root   35 Dec 13 11:28 sos_logs
drwx------  2 root root   37 Dec 13 11:28 sos_reports
dr-xr-xr-x 10 root root  112 Dec 12 15:35 sys
lrwxrwxrwx  1 root root   28 Dec 13 11:26 uname -> sos_commands/kernel/uname_-a
lrwxrwxrwx  1 root root   27 Dec 13 11:26 uptime -> sos_commands/general/uptime
drwxr-xr-x  5 root root   42 Sep 27 14:07 usr
drwxr-xr-x  7 root root   69 Dec 12 15:35 var
-rw-r--r--  1 root root 1946 Dec 13 11:28 version.txt
lrwxrwxrwx  1 root root   62 Dec 13 11:26 vgdisplay -> sos_commands/lvm2/vgdisplay_-vv_--config_global_locking_type_0
[root@clu_1 sosreport-clu1-20181213112633]#

```



# SOSReprot 내부 행동 #

- SOSReport는 아래와 동일한 행위를 수행한다. 

```bash
#!/bin/bash
host="$(hostname)"

sos_dir="/tmp/${host}_hungsos"
mkdir $sos_dir
cd $sos_dir
chkconfig --list > chkconfig
date > date
df > df
dmesg > dmesg
dmidecode > dmidecode
fdisk -l > fdisk
free > free
hostname --fqdn > hostname
ifconfig > ifconfig
lsmod > lsmod
lspci > lspci
cat /proc/mounts > mount
netstat -tlpn > netstat
ps auxww > ps
rpm -qa > rpm-qa
rpm -Va > rpm-Va     #this command may take a while to run
ulimit -a > ulimit
uname -a > uname
uptime > uptime
cat /proc/meminfo > meminfo
cat /proc/cpuinfo > cpuinfo
mkdir etc
cd etc
cp /etc/fstab .
cp /etc/cluster/cluster.conf .
cp /etc/security/limits.conf .
cp /etc/redhat-release .
cp /etc/sysctl.conf .
cp /etc/modprobe.conf .
mkdir sysconfig/network-scripts -p
cd sysconfig
cp /etc/sysconfig/* . -R
cd $sos_dir
mkdir var/log -p
cp /var/log/* var/log -R
cd /tmp
tar -cvjf ${host}_hungsos.tar.bz2 $sos_dir
```

