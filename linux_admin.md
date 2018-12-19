# Linux Basic 





## booting Process

- disk blocksize
```blockdev --getbsz /dev/sda
4096 
```
> 위 결과는 Disk의 Block 사이즈 단위 가 4K라는 것을 알 수 있다.

```
[root@clu_1 docker]# echo "test" > test.txt
[root@clu_1 docker]# du -h test
4.0K    test
```
> 위의 결과를 살펴 보면, 가장 단순한 파일 하나도 4 Kbyte가 할당 되어 있음을 알 수 있다. 즉, Disk에서 가장 작은 단위는 4 Kbyte 임을 확인 할 수 있다. 


## MBR



## bash







## docker : chroot / cgroups / namespace

> chroot




## env
> env
> env | grep PATH
> whereis ls
- PATH에는 우선 순위가 있다. 로컬 디렉터리에 동일한 **ls** 명령어가 있다고 하더라도, PATH 환경변수의 우선순위가에 따라 실행한다. 즉, **ls**와 **./ls**는 다르다.
```bash
[root@clu_1 tmp]# env | grep PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```
- 환경변수에 매번 추가하기 위해서는, **.bash_profile** 도는 **.bashrc**를 통해서 설정할 수 있다. 




## chage
- 사용자 계정의 기간 만료를 설정한다. 
> chage -l root


## su / sudo 
- su : switch user
- sudo : root와 동일한 권한으로 실행한다. 

```bash
[root@clu_1 docker]# ll /etc/sudoers  
```

```bash
[root@clu_1 docker]# ll /etc/sudoers
-r--r-----. 1 root root 3907 Nov  5  2016 /etc/sudoers

```



## Permission 
- setuid, setguid
- sticky 권한 (t)

```bash
[root@clu_1 docker]# 
drwxrwxrwt.  23 root root  4096 Dec 19 11:11 tmp
```




# Network


## netstat

## ss ( CentOS 7 부터 기본 사용)
- ss 명령어가 좀 더 최적화 되어 있다. 좀 더 빠르다. 



## Bonding 

- 물리적인 다수개의 NIC카드를 하나로 묶어서 논리적인 NIC 카드 1개로 인식
> network Interface 이중화이며, Windows는 티밍과 동일하다. 

- Bonding은 총 7개의 mode를 가지고 있다. 


- network device 정보를 확인한다. (bonding을 구성한 네트워크 정보를 확인한다.)
```bash
$ cat /proc/net/dev
[root@clu_2 ~]# cat /proc/net/dev
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
enp0s3:   16114     119    0    0    0     0          0         0    29953     224    0    0    0     0       0          0
enp0s8:    3416      22    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 bond0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
    lo:  208634    2050    0    0    0     0          0         0   208634    2050    0    0    0     0       0          0
```

- `vi /etc/modprobe.d/bonding.conf` 에서 본딩 설정을 한다. 
```bash
[root@clu_1 bin]# cat /etc/modprobe.d/bonding.conf
alias bond0 bonding
```
> 여기에서는, boding 할 대상을 enp0s3, enp0s8로 가정한다.


- Bonding 구성 후 
```bash
[root@clu_2 ~]# cat /proc/net/dev
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
enp0s3:  406104    1482    0    0    0     0          0        26 18887829   56721    0    0    0     0       0          0
enp0s8:   80442    1157    0    0    0     0          0        17     8125      50    0    0    0     0       0          0
 **bond0:    3382      25    0    0    0     0          0         2     4053      21    0    0    0     0       0          0 **
    lo: 5874918   19624    0    0    0     0          0         0  5874918   19624    0    0    0     0       0          0
[root@clu_2 ~]# 
[root@clu_2 ~]# ifconfig
bond0: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500
        inet 192.168.56.102  netmask 255.255.255.0  broadcast 192.168.56.255
        inet6 fe80::a00:27ff:fe87:b86  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:87:0b:86  txqueuelen 1000  (Ethernet)
        RX packets 59  bytes 6284 (6.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 21  bytes 4053 (3.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```
> `[root@clu_2 ~]# ifdown enp0s3` 을 사용하여 enp0s3를 다운시켜도, Network는 동작하는 것을 확인 할 수 있다. 

```bash
[root@clu_2 ~]# ifdown enp0s3
[root@clu_2 ~]# ifconfig
bond0: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500
        inet 192.168.56.102  netmask 255.255.255.0  broadcast 192.168.56.255
        inet6 fe80::a00:27ff:fe87:b86  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:87:0b:86  txqueuelen 1000  (Ethernet)
        RX packets 119  bytes 11582 (11.3 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 42  bytes 6469 (6.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp0s8: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500
        ether 08:00:27:87:0b:86  txqueuelen 1000  (Ethernet)
        RX packets 1251  bytes 88642 (86.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 71  bytes 10541 (10.2 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1  (Local Loopback)
        RX packets 19630  bytes 5875446 (5.6 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 19630  bytes 5875446 (5.6 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```




# logs

## journal
 - 

- journalctl
  : journalctl -r 옵션 : 뒤에서 부터 볼 수 있다. 
- /var/log/messages : info에 해당하는 로그만
- /var/log/dmesg  ==> `journalctl -k`와 동일










