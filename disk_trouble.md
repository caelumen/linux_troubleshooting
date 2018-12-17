# 디스크 관련 트러블슈팅 : disk free/usage/mount/fstab #

# disk free (df) #
 - 파일시스템/디스크 용량 확인
df

df -h : 읽기 쉽게 출력 (human-readable)
```bash
[root@clu_1 sosreport-clu1-20181213112633]# df -h
Filesystem           Size  Used Avail Use% Mounted on
/dev/mapper/cl-root   10G  7.0G  3.1G  70% /
devtmpfs             905M     0  905M   0% /dev
tmpfs                920M   84K  920M   1% /dev/shm
tmpfs                920M  8.8M  912M   1% /run
tmpfs                920M     0  920M   0% /sys/fs/cgroup
/dev/sda1           1014M  172M  843M  17% /boot
tmpfs                184M   16K  184M   1% /run/user/42
tmpfs                184M     0  184M   0% /run/user/0
```

df -i : inode 정보 출력
```bash
[root@clu_1 sosreport-clu1-20181213112633]# df -i
Filesystem           Inodes  IUsed   IFree IUse% Mounted on
/dev/mapper/cl-root 5240832 194089 5046743    4% /
devtmpfs             231549    407  231142    1% /dev
tmpfs                235459      6  235453    1% /dev/shm
tmpfs                235459    539  234920    1% /run
tmpfs                235459     16  235443    1% /sys/fs/cgroup
/dev/sda1            524288    330  523958    1% /boot
tmpfs                235459     17  235442    1% /run/user/42
tmpfs                235459      2  235457    1% /run/user/0
```



# 디스크 사용량 확인 (disk usage; du) #

- du
```bash
[root@clu_1 sosreport-clu1-20181213112633]# du | more
4       ./sos_commands/kpatch
296     ./sos_commands/networking
4       ./sos_commands/virsh
4       ./sos_commands/abrt
8       ./sos_commands/ata
  [생  략]
```


## 현재 디렉토리의 용량확인 ##
```
[root@clu_1 ~]# du -hs
799M    .
```
- options : h (human-readable), s (summary)

## 현재 디렉토리 및 파일 용량 확인 ##
```
[root@clu_1 ~]# du -hs *
4.0K    anaconda-ks.cfg
0       Desktop
76K     dmidecode.txt
0       Dockerfile
```

- 현재 폴더에 있는 폴더/파일 중에서 용량이 큰것 순으로 10개 보기
```
[root@clu_1 ~]# du -hsx * | sort -rh | head -n 10
738M    vmcore
36M     package
128K    lkm
76K     dmidecode.txt
52K     lspci.txt
12K     sample.csv
12K     multipath_ll.txt
12K     lsscsi.txt
4.0K    multipath_conf.txt
4.0K    initial-setup-ks.cfg
```

- 특정 디렉터리(/usr) 하위 욜양 보기
```
[root@clu_1 ~]# du -hs /usr/*
203M    /usr/bin
0       /usr/etc
0       /usr/games
9.6M    /usr/include
641M    /usr/lib
1.3G    /usr/lib64
```

# 디스크의 용량 확인 (fdisk) #
- fdisk의 파티션 정보 활용
- fdisk -l 옵션 : list partition tables

```
fdisk -l | grep Disk
```

```
 fdisk -l | egrep 'Disk.*bytes'
```





# fstab #
- 부팅 시 자동으로 마운트 

fdisk -l


disk를 마운트 할 때, /dev/sda1 등의 Disk이름은 변경될 수 있으므로, 
disk의 uuid를 사용한다. 

```
[root@clu_1 ~]# blkid
/dev/sda1: UUID="5acf284e-58fa-4819-8cd9-fcd0152dcde0" TYPE="xfs"
/dev/sda2: UUID="mtGfIk-bgxw-Ot2w-pian-1gu7-acSD-mjdXju" TYPE="LVM2_member"
/dev/sdb1: UUID="xPTmru-6sER-2O6c-I4PA-UPm8-ZME7-MHetXR" TYPE="LVM2_member"
/dev/mapper/cl-root: UUID="b587c2f3-973b-466b-bbe1-dfdcae0bb792" TYPE="xfs"
/dev/mapper/cl-swap: UUID="553d2364-70c2-43d3-b38a-afa138789b1b" TYPE="swap"
/dev/mapper/VG01-note8: UUID="e42a0847-9732-49cc-8e8b-248b09d475c5" TYPE="xfs"
```


### mount할 디렉터리 생성 ###
mkdir /mnt/c


### /etc/fstab 파일 수정 ###
- root 권한으로 /etc/fstab 파일을 열어 내용을 추가
- fstab은 총 6개 필드로 구성
  1) 마운트할 장치의 파일명 (UUID)
  2) 마운트 포인트 (마운트될 directory명)
  3) 마운트할 파일시스템 종류
  4) 마운트 옵션
  5) 해당 파티션을 백업할지 여부
  6) fsck에 의한 파일시스템 검사 여부 (0-검사하지 않음, 1-파일시스템, 2-기타)






### USB 삽입 ###
```bash
[root@clu_1 ~]# fdisk -l | grep Disk.*bytes
Disk /dev/sda: 12.9 GB, 12884901888 bytes, 25165824 sectors
Disk /dev/sdb: 1073 MB, 1073741824 bytes, 2097152 sectors
Disk /dev/mapper/cl-root: 10.7 GB, 10733223936 bytes, 20963328 sectors
Disk /dev/mapper/cl-swap: 1069 MB, 1069547520 bytes, 2088960 sectors
Disk /dev/mapper/VG01-note8: 20 MB, 20971520 bytes, 40960 sectors
Disk /dev/sdc: 7948 MB, 7948206080 bytes, 15523840 sectors
```

```bash
[root@clu_1 ~]# cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Thu Sep 27 14:07:17 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/cl-root     /                       xfs     defaults        0 0
UUID=5acf284e-58fa-4819-8cd9-fcd0152dcde0 /boot                   xfs     defaults        0 0
/dev/mapper/cl-swap     swap                    swap    defaults        0 0
[root@clu_1 ~]# blkid
/dev/sda1: UUID="5acf284e-58fa-4819-8cd9-fcd0152dcde0" TYPE="xfs"
/dev/sda2: UUID="mtGfIk-bgxw-Ot2w-pian-1gu7-acSD-mjdXju" TYPE="LVM2_member"
/dev/sdb1: UUID="xPTmru-6sER-2O6c-I4PA-UPm8-ZME7-MHetXR" TYPE="LVM2_member"
/dev/mapper/cl-root: UUID="b587c2f3-973b-466b-bbe1-dfdcae0bb792" TYPE="xfs"
/dev/mapper/cl-swap: UUID="553d2364-70c2-43d3-b38a-afa138789b1b" TYPE="swap"
/dev/mapper/VG01-note8: UUID="e42a0847-9732-49cc-8e8b-248b09d475c5" TYPE="xfs"
/dev/sdc1: UUID="3932-3133" TYPE="vfat"
```

```
$ mkdir /mnt/usb
```


`/etc/fstab`에 아래 내용 추가
```bash
[root@clu_1 ~]# cat /etc/fstab
UUID=3932-3133          /mnt/usb                vfat    defaults        0 0

```














