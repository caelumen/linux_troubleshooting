# 1. Linux Kernel Module 개요 #

CentOS 등 Linux 시스템에서 Kernel mode에서 동작하는 프로그램을 위해서는, Kernel Module을 작성하여, 모듈을 등록한다. 
디바이스 드라이버와 같은 Kernel Module들이 바로 이것이다. 

Kernel Module을 컴파일하기 위해서는, Kernel Module이 사용하는 함수/구조체/상수 등에대한 definition을 포함하고 있는 Header파일 (C언어)가 필요하다. 이러한, Header파일은 Package Manager를 사용하여 설치할 수 있는데, 이 때, 커널버전을 일치 시켜야 한다. 

만약, Kernel upgrade 등으로 커널 버전을 변경했다면, Kernel Version에 매칭 되는 Kernel-Header를 설치해야하며, 
Source로부터 커널을 컴파일하여 Kernel을 사용한다며, 필히 소스로부터 kernel header로 부터 인스톨 해야 한다. 

kernel header 등은 kernel-devel package를 설치하면 된다. 

다음 위치를 확인해 해본다. 만약, 마무런 파일/디렉토리가 없다면, kernel-devel이 설치되지 않은것 이므로 yum을 통하여 설치하도록 한다.
~~~
[root@clu_1 lkm]# ll /usr/src/kernels/
total 4
drwxr-xr-x 22 root root 4096 Oct 19 09:26 3.10.0-514.el7.x86_64
~~~
위는 3.10.0 대 커널의 kernel-devel이 설치되어 있다. 

아무것도 설치가 되어 있지 않다면, 아래처러 추가 설치 할 수 있다. 
~~~
[root@clu_1 lkm]# yum install kernel-devel
[root@clu_1 lkm]# ls -l /usr/src/kernels/$(uname -r)
~~~
설치 후, `$(uname -r)`을 통하여 현재 버전에 맞는 커널인지 재확인 할 수 있다. 


또한, glibc의 사용이 필요할 경우, kernel-header 패키지를 설치하면 된다. 
~~~
[root@clu_1 lkm]# yum install kernel-headers
~~~

# 2. Kernel module 설치 및 Build #

- Kernel-devel을 통한 Kernel header 등 개발에 필요한 소스들이 설치 되었다면, 실제 Kernel module을 빌드해 보자.
- 우선 Kernel module에 대한 Hello world 샘플이다. 

## kernel module 샘플 ##
~~~
#include <linux/module.h>    // included for all kernel modules
#include <linux/kernel.h>    // included for KERN_INFO
#include <linux/init.h>      // included for __init and __exit macros

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Lakshmanan");
MODULE_DESCRIPTION("A Simple Hello World module");

static int __init hello_init(void)
{
    printk(KERN_INFO "Hello world!\n");
    return 0;    // Non-zero return means that the module couldn't be loaded.
}

static void __exit hello_cleanup(void)
{
    printk(KERN_INFO "Cleaning up module.\n");
}

module_init(hello_init);
module_exit(hello_cleanup);
~~~

- hello.c를 작성했다면, Compile을 해야 한다. 
- CC hello.c -o hello 를 통하여 컴파일을 할 수 있을 것이다.
- 그러나, Kernel Module Build에 필요한 라이브러리/Header 등 경로가 다소 복잡할 수 있으므로, 
- Makefile Macro를 통하여 옵션들을 설정하여 준다. 
* Makefile 내에서 make 명령어를 실행하는 부분은 첫문자열이 <Tab> 문자열로 시작하여야 한다. 


## Makefile 샘플 1 ##
~~~
obj-m+=hello.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
~~~


## Makefile 샘플2 ##
~~~
obj-m+=hello.o

KSRC := /lib/modules/$(shell uname -r)/build

all:
	make -C $(KSRC) M=$(PWD) modules
	$(CC) hello.c -o test
clean:
	make -C $(KSRC) M=$(PWD) clean
	rm test


[root@clu_1 lkm]# make KSRC=/usr/src/linux-headers-4.9.2 all
[root@clu_1 lkm]# make KSRC=/lib
~~~


## Compile/make 실행 ##
다시 강조하면, Makefile (make용 Macro)에서 make 실행 명령어 부분의 앞은 TAB으로 구분/분리 해야 한다. 
ex) \t make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules


- make를 실행하여 Compile한다. 

~~~
[root@clu_1 lkm]# make
make -C /lib/modules/3.10.0-514.el7.x86_64/build M=/root/lkm modules
make[1]: Entering directory `/usr/src/kernels/3.10.0-514.el7.x86_64'
  Building modules, stage 2.
  MODPOST 1 modules
make[1]: Leaving directory `/usr/src/kernels/3.10.0-514.el7.x86_64'
~~~

- Compile 후 생성 `hello.o`, `hello.ko` 및 `hello.mod.o` 등이 바이너리 파일이 생성 된다. 
~~~
[root@clu_1 lkm]# ll
total 208
-rw-r--r-- 1 root root   596 Dec 11 18:40 hello.c
-rw-r--r-- 1 root root 94752 Dec 11 18:41 hello.ko
-rw-r--r-- 1 root root   736 Dec 11 18:41 hello.mod.c
-rw-r--r-- 1 root root 52792 Dec 11 18:41 hello.mod.o
-rw-r--r-- 1 root root 43488 Dec 11 18:41 hello.o
-rw-r--r-- 1 root root   140 Dec 11 18:41 Makefile
-rw-r--r-- 1 root root    26 Dec 11 19:28 modules.order
-rw-r--r-- 1 root root     0 Dec 11 18:41 Module.symvers
~~~

# 3. Linux Kernel Module Loading #

## Kernel Module 로딩 ##
- Compile된 모듈을 Kernel Module로 로딩 시킨다. (insmod)
~~~
[root@clu_1 lkm]# insmod hello.ko
[root@clu_1 lkm]# lsmod | grep hello
hello                  12428  0
~~~

- Kernel Module로 로딩이 되면, `printk` 명령어에 의하여 Kernel Message를 출력한다. 
- journalctl에 따라서, 어디에 로그를 남기는지가 결정될것이나, 현재는 messages로그에 출력된다. 
~~~
[root@clu_1 lkm]# tail -20 /var/log/messages
Dec 11 19:20:01 clu_1 systemd: Started Session 9 of user root.
Dec 11 19:20:01 clu_1 systemd: Starting Session 9 of user root.
Dec 11 19:24:22 clu_1 ntpd[732]: 0.0.0.0 0613 03 spike_detect -0.143624 s
Dec 11 19:27:36 clu_1 kernel: Hello world!
Dec 11 19:30:01 clu_1 systemd: Started Session 10 of user root.
Dec 11 19:30:01 clu_1 systemd: Starting Session 10 of user root.
~~~

- Kernel module 제거 (rmmod hello.ko - 마지막에 `.ko`를 붙여주어야 한다)
~~~
[root@clu_1 lkm]# rmmod hello.ko
[root@clu_1 lkm]# lsmod | grep hello
[root@clu_1 lkm]# tail /var/log/messages
Dec 11 19:24:22 clu_1 ntpd[732]: 0.0.0.0 0613 03 spike_detect -0.143624 s
Dec 11 19:27:36 clu_1 kernel: Hello world!
Dec 11 19:30:01 clu_1 systemd: Started Session 10 of user root.
Dec 11 19:30:01 clu_1 systemd: Starting Session 10 of user root.
Dec 11 19:34:16 clu_1 PackageKit: uid 1000 is trying to obtain org.freedesktop.packagekit.system-sources-refresh auth (only_trusted:0)
Dec 11 19:34:17 clu_1 PackageKit: uid 1000 obtained auth for org.freedesktop.packagekit.system-sources-refresh
Dec 11 19:34:40 clu_1 PackageKit: refresh-cache transaction /78_aecadbdd from uid 1000 finished with success after 23630ms
Dec 11 19:34:46 clu_1 PackageKit: get-updates transaction /79_bddeaebe from uid 1000 finished with success after 5362ms
Dec 11 19:35:21 clu_1 PackageKit: update-packages transaction /80_adeaccce from uid 1000 finished with success after 35376ms
Dec 11 19:35:35 clu_1 kernel: Cleaning up module.
~~~



# standard Lib Path #

- `#include <stdio.h>`와 같이 표준라이브러리를 입력한다면, 어떤 경로를 참조할까??
- 이는, `/etc/ld.so.conf`를 참조한다. 
- /etc/ld.so.conf 내용을 보면 아래와 같은 설정으로 되어 있다. 
~~~
include ld.so.conf.d/*.conf
~~~
즉, standard lib는 /etc/ld.so.conf.d/*.conf로 되어있는 파일을 참조하여 파일내에 있는 경로를 include 경로로 사용한다. 

따라서, Standard Lib를 찾지 못할 경우, 아래와 같은 경로 추가가 필요하다. 

~~~
touch /etc/ld.so.conf.d/lkm_test.conf
vi /etc/ld.so.conf.d/lkm_test.conf
~~~
아래 내용 입력
~~~
/lib/modules/3.10.0-514.el7.x86_64/build/include/
~~~

내용을 입력후 config를 반영한다. 
~~~
ldconfig
~~~


# 4. Linux Kernel Module Fault #

## Build/compile with fault ##
- 고의적으로 fault를 발생하는 hello_2.c를 생성한다. 
- hello_cleanup()에 임의의 seg fault 를 발생한다. 
~~~
#include <linux/module.h>    // included for all kernel modules
#include <linux/kernel.h>    // included for KERN_INFO
#include <linux/init.h>      // included for __init and __exit macros

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Lakshmanan");
MODULE_DESCRIPTION("A Simple Hello World module");

static int __init hello_init(void)
{
    printk(KERN_INFO "Hello world!\n");
    return 0;    // Non-zero return means that the module couldn't be loaded.
}

static void __exit hello_cleanup(void)
{
    int *p = NULL;
    printk("Intentionally generating fault!\n");
    *p=1;
    printk(KERN_INFO "Cleaning up module.\n");
}

module_init(hello_init);
module_exit(hello_cleanup);
~~~

- Makefile을 수정한다. (`obj-m+=hello_2.c` 추가)

~~~
obj-m+=hello.o
obj-m+=hello_2.o

KSRC := /lib/modules/$(shell uname -r)/build

all:
        make -C $(KSRC) M=$(PWD) modules
clean:
        make -C $(KSRC) M=$(PWD) clean
~~~



~~~
[root@clu_1 lkm]# ll
total 408
-rw-r--r-- 1 root root   674 Dec 12 09:47 hello_2.c
-rw-r--r-- 1 root root 95104 Dec 12 09:48 hello_2.ko
-rw-r--r-- 1 root root   736 Dec 12 09:48 hello_2.mod.c
-rw-r--r-- 1 root root 52800 Dec 12 09:48 hello_2.mod.o
-rw-r--r-- 1 root root 43824 Dec 12 09:48 hello_2.o
-rw-r--r-- 1 root root   596 Dec 11 18:40 hello.c
-rw-r--r-- 1 root root 94752 Dec 11 18:41 hello.ko
-rw-r--r-- 1 root root   736 Dec 11 18:41 hello.mod.c
-rw-r--r-- 1 root root 52792 Dec 11 18:41 hello.mod.o
-rw-r--r-- 1 root root 43488 Dec 11 18:41 hello.o
-rw-r--r-- 1 root root   157 Dec 12 09:48 Makefile
-rw-r--r-- 1 root root    54 Dec 12 09:48 modules.order
-rw-r--r-- 1 root root     0 Dec 11 18:41 Module.symvers
[root@clu_1 lkm]# lsmod | grep hello
[root@clu_1 lkm]# insmod hello_2.ko
[root@clu_1 lkm]# lsmod | grep hello
hello_2                12428  0
~~~

~~~
[root@clu_1 lkm]# tail -f /var/log/messages
Dec 12 09:50:01 clu_1 systemd: Started Session 15 of user root.
Dec 12 09:50:01 clu_1 systemd: Starting Session 15 of user root.
Dec 12 09:51:42 clu_1 kernel: Hello world!
~~~

## Kernel Fault 발생 ##

아래를 실행하면 시스템은 Kernel Crash가 발생한다. 
~~~
rmmod hello_2.ko
~~~

- last 로그를 보면, crash가 발생하고 reboot가 일어난 것을 알 수 있다. 
~~~
[root@clu_1 ~]# last
root     pts/0        192.168.56.1     Wed Dec 12 09:56   still logged in
(unknown :0           :0               Wed Dec 12 09:55   still logged in
reboot   system boot  3.10.0-514.el7.x Thu Dec  6 20:58 - 10:01 (5+13:02)
root     pts/3        192.168.56.1     Wed Dec 12 09:52 - crash (-5+-12:-54)
root     pts/2        192.168.56.1     Wed Dec 12 09:45 - crash (-5+-12:-47)
root     pts/1        192.168.56.1     Tue Dec 11 18:38 - crash (-4+-21:-40)
~~~

- `/var/log/messages`를 살펴보면, kernel module에서 printk에 의하여 발생하는 message를 확인 할 수 있다. 
- Crash 발생에 따른, kdump 및 kexec가 실행 되었고, dump file은 /var/crash에서 vmcore를 확인 할 수 있다. 

~~~
[root@clu_1 127.0.0.1-2018-12-06-21:20:34]# ll /var/crash
total 0
drwxr-xr-x 2 root root 44 Sep 27 15:13 127.0.0.1-2018-09-27-15:13:14
drwxr-xr-x 2 root root 44 Dec  6 20:57 127.0.0.1-2018-12-06-20:57:46
drwxr-xr-x 2 root root 44 Dec  6 21:20 127.0.0.1-2018-12-06-21:20:34
~~~

~~~

[root@clu_1 127.0.0.1-2018-12-06-21:20:34]# cat vmcore-dmesg.txt
[ 1326.958977] Hello world!
[ 1346.315773] Intentionally generating fault!
[ 1346.315801] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1346.316037] IP: [<ffffffffa05cc012>] hello_cleanup+0x12/0x1000 [hello_2]
[ 1346.316195] PGD 57922067 PUD 578c9067 PMD 0
[ 1346.316301] Oops: 0002 [#1] SMP
       [중         략]
[ 1346.356299] Call Trace:
[ 1346.357842]  [<ffffffff810fdd4b>] SyS_delete_module+0x16b/0x2d0
[ 1346.359786]  [<ffffffff816965c9>] system_call_fastpath+0x16/0x1b
[ 1346.361546] Code: <c7> 04 25 00 00 00 00 01 00 00 00 48 c7 c7 34 d0 5c a0 31 c0 e8 cb
[ 1346.363253] RIP  [<ffffffffa05cc012>] hello_cleanup+0x12/0x1000 [hello_2]
[ 1346.364549]  RSP <ffff880035d4fef0>
[ 1346.366492] CR2: 0000000000000000
~~~

- Oops 코드가 0002를 볼 때,  No Page found, Read/Execute, Kernel mode의 에러임을 알수 있다. 
- RIP 가 hello_cleanup에서 에러가 발생 했다. [hello_2] 라는 영역인것을 확인 할 수 있다. 

## Crash 분석 ##
~~~
[root@clu_1 127.0.0.1-2018-12-06-21:20:34]# pwd
/var/crash/127.0.0.1-2018-12-06-21:20:34
[root@clu_1 127.0.0.1-2018-12-06-21:20:34]# find / -name vmlinux
find: ‘/run/user/42/gvfs’: Permission denied
/root/vmcore/2.6.32-504.el6.x86_64/vmlinux
/root/vmcore/3.10.0-514.el7.x86_64/vmlinux
/root/vmcore/3.10.0-862.11.6.el7.x86_64/vmlinux
[root@clu_1 127.0.0.1-2018-12-06-21:20:34]# crash /root/vmcore/3.10.0-514.el7.x86_64/vmlinux ./vmcore
~~~


## sys info ##
~~~
 KERNEL: /root/vmcore/3.10.0-514.el7.x86_64/vmlinux
    DUMPFILE: ./vmcore  [PARTIAL DUMP]
        CPUS: 2
        DATE: Wed Dec 12 10:17:33 2018
      UPTIME: 00:22:26
LOAD AVERAGE: 0.00, 0.01, 0.05
       TASKS: 287
    NODENAME: clu_1
     RELEASE: 3.10.0-514.el7.x86_64
     VERSION: #1 SMP Tue Nov 22 16:42:41 UTC 2016
     MACHINE: x86_64  (2394 Mhz)
      MEMORY: 2 GB
       PANIC: "BUG: unable to handle kernel NULL pointer dereference at           (null)"
         PID: 3787
     COMMAND: "rmmod"
        TASK: ffff880057842f10  [THREAD_INFO: ffff880035d4c000]
         CPU: 0
       STATE: TASK_RUNNING (PANIC)
~~~


## backtrace ##
~~~
crash> bt
PID: 3787   TASK: ffff880057842f10  CPU: 0   COMMAND: "rmmod"
 #0 [ffff880035d4fb80] machine_kexec at ffffffff81059cdb
 #1 [ffff880035d4fbe0] __crash_kexec at ffffffff81105182
 #2 [ffff880035d4fcb0] crash_kexec at ffffffff81105270
 #3 [ffff880035d4fcc8] oops_end at ffffffff8168ee88
 #4 [ffff880035d4fcf0] no_context at ffffffff8167ea93
 #5 [ffff880035d4fd40] __bad_area_nosemaphore at ffffffff8167eb29
 #6 [ffff880035d4fd88] bad_area at ffffffff8167ee4d
 #7 [ffff880035d4fdb0] __do_page_fault at ffffffff81691d1f
 #8 [ffff880035d4fe10] do_page_fault at ffffffff81691dc5
 #9 [ffff880035d4fe40] page_fault at ffffffff8168e088
    [exception RIP: cleanup_module+18]
    RIP: ffffffffa05cc012  RSP: ffff880035d4fef0  RFLAGS: 00010246
    RAX: 000000000000001f  RBX: fffffffffffffff5  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: ffff88007fc0f838  RDI: ffff88007fc0f838
    RBP: ffff880035d4fef0   R8: 0000000000000096   R9: 000000000000020f
    R10: 0000000000000000  R11: ffff880035d4fbf6  R12: ffffffffa05ce000
    R13: 0000000000000800  R14: 0000000001ef1260  R15: 0000000001ef0010
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
#10 [ffff880035d4fef8] sys_delete_module at ffffffff810fdd4b
#11 [ffff880035d4ff80] system_call_fastpath at ffffffff816965c9
    RIP: 00007f3580f2b097  RSP: 00007ffe5c67a608  RFLAGS: 00010202
    RAX: 00000000000000b0  RBX: ffffffff816965c9  RCX: 0000000000000000
    RDX: 00007f3580f9f200  RSI: 0000000000000800  RDI: 0000000001ef12c8
    RBP: 0000000000000000   R8: 00007f35811f3060   R9: 00007f3580f9f200
    R10: 00007ffe5c67a060  R11: 0000000000000202  R12: 0000000000000000
    R13: 00007ffe5c67c87a  R14: 0000000001ef1260  R15: 00000000f48ec800
    ORIG_RAX: 00000000000000b0  CS: 0033  SS: 002b

~~~

~~~
crash> dis cleanup_module+18
    [중    략]
ffffffffa05cc012 (t) cleanup_module+18 [hello_2]

crash> mod
    [중    략]
ffffffffa05c61a0  fuse                     87741  (not loaded)  [CONFIG_KALLSYMS]
ffffffffa05ce000  hello_2                  12428  (not loaded)  [CONFIG_KALLSYMS]
ffffffffa05d8120  binfmt_misc              17468  (not loaded)  [CONFIG_KALLSYMS]
crash>
~~~

- 다시, log 명령어를 통하여, rmmod / cleanup_module 실행할 때 어떤 module에서 발생했는지 확인한다. 
- 결과적으로, hello_2 명령어를 loading하고, 모듈을 제거(rmmod)할 때 Crash가 발생했음을 알 수 있다. 
~~~
crash> log
    [중    략]
[ 1326.958977] Hello world!
[ 1346.315773] Intentionally generating fault!
[ 1346.315801] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1346.316037] IP: [<ffffffffa05cc012>] hello_cleanup+0x12/0x1000 [hello_2]
[ 1346.316195] PGD 57922067 PUD 578c9067 PMD 0
[ 1346.316301] Oops: 0002 [#1] SMP
~~~

- 문제가 되는 모듈인 hello_cleanup을 확인한다. 
- 문제의 발생은 cleanup_modul+18에서 발생하고 있으며, 
- 잘못된 메모리 참조( `movl $0x1, 0x0`)로 인한 커널로 확인 된다. 

~~~
crash> dis hello_cleanup
0xffffffffa05cc000 <hello_cleanup>:     push   %rbp
0xffffffffa05cc001 <cleanup_module+1>:  mov    $0xffffffffa05cd050,%rdi
0xffffffffa05cc008 <cleanup_module+8>:  xor    %eax,%eax
0xffffffffa05cc00a <cleanup_module+10>: mov    %rsp,%rbp
0xffffffffa05cc00d <cleanup_module+13>: callq  0xffffffff8167f4f6 <printk>
0xffffffffa05cc012 <cleanup_module+18>: movl   $0x1,0x0
0xffffffffa05cc01d <cleanup_module+29>: mov    $0xffffffffa05cd034,%rdi
0xffffffffa05cc024 <cleanup_module+36>: xor    %eax,%eax
0xffffffffa05cc026 <cleanup_module+38>: callq  0xffffffff8167f4f6 <printk>
0xffffffffa05cc02b <cleanup_module+43>: pop    %rbp
0xffffffffa05cc02c <cleanup_module+44>: retq
~~~


## 그 밖의 정보 출력/확인 ##
- 이번 예제에서는 특별한 의미는 없으나, memory를 확인한다. 

~~~
crash> kmem -i
                 PAGES        TOTAL      PERCENTAGE
    TOTAL MEM   470918       1.8 GB         ----
         FREE   285109       1.1 GB   60% of TOTAL MEM
         USED   185809     725.8 MB   39% of TOTAL MEM
       SHARED    29706       116 MB    6% of TOTAL MEM
      BUFFERS      278       1.1 MB    0% of TOTAL MEM
       CACHED   105548     412.3 MB   22% of TOTAL MEM
         SLAB    13282      51.9 MB    2% of TOTAL MEM

   TOTAL SWAP   261119      1020 MB         ----
    SWAP USED        0            0    0% of TOTAL SWAP
    SWAP FREE   261119      1020 MB  100% of TOTAL SWAP

 COMMIT LIMIT   496578       1.9 GB         ----
    COMMITTED   408850       1.6 GB   82% of TOTAL LIMIT
~~~

- Network connection 및 interface를 확인한다. (특이 사항 없음)
~~~
crash> net -a
NEIGHBOUR        IP ADDRESS      HW TYPE    HW ADDRESS         DEVICE  STATE
ffff88007a4e6e00 239.255.255.250 ETHER      01:00:5e:7f:ff:fa  enp0s3  NOARP
ffff880035370e00 192.168.56.1    ETHER      0a:00:27:00:00:1c  enp0s8  REACHABLE
ffff88007b8b3400 224.0.0.22      ETHER      01:00:5e:00:00:16  enp0s3  NOARP
ffff8800796f5800 224.0.0.22      ETHER      01:00:5e:00:00:16  enp0s8  NOARP
ffff880035ccc800 224.0.0.251     ETHER      01:00:5e:00:00:fb  enp0s3  NOARP
ffff8800796f5e00 127.0.0.1       UNKNOWN    00 00 00 00 00 00  lo      NOARP
ffff8800796f5600 224.0.0.251     ETHER      01:00:5e:00:00:fb  enp0s8  NOARP
ffff88007a4e8400 224.0.0.251     ETHER      01:00:5e:00:00:fb  docker0  NOARP
ffff88007b9cfc00 224.0.0.22      ETHER      01:00:5e:00:00:16  docker0  NOARP
ffff88007af3f200 10.0.2.2        ETHER      52:54:00:12:35:02  enp0s3  STALE

~~~


# 실습 #

```bash
$ yum install git -y
$ git clone https://github.com/windflex-sjlee/linux_kernel_module.git
$ linux_kernel_module/install.sh
$ linux_kernel_module/fault.sh
```

