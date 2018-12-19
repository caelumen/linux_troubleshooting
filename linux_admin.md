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








