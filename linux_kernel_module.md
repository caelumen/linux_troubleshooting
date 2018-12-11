# Linux Kernel Module #

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

# Kernel module #

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
- CC hello -o hello.c 를 통하여 컴파일을 할 수 있을 것이다.
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
	$(CC) Hello.c -o test
clean:
	make -C $(KSRC) M=$(PWD) clean
	rm test


[root@clu_1 lkm]# make KSRC=/usr/src/linux-headers-4.9.2 all
[root@clu_1 lkm]# make KSRC=/lib
~~~


## Makefile ##
Makefile (make용 Macro)에서 make 실행 명령어 부분의 앞은 TAB으로 구분/분리 해야 한다. 
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



