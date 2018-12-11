# Linux Kernel Module #


CentOS 등 시스템에서 디바이스 드라이버와 같은 커스텀 Kernel Module을 컴파일하기위해서는,
Kernel header file을 시스템에 인스톨 해야 한다. 
kernel header file은 Linux Kernel을 위한 C의 Header파일을 포함하며, 
Kernel과 인터페이스를 위한 코드 작성을 위한 함수/구조체 등의 Definition을 제공한다.

Kernel Header를 설치할 때, 현재 Kernel 버전을 확이이 꼭 필요하다. 
만약 Kernel Version 버전을 변경(Kernel Upgrade 등으로)했다면 커너버전에 매칭되는
 package manager를 사용하여 Kernel header를 일치 시켜야만 한다. 

만약, Source로 부터 커널을 컴파일했다면, 소스로부터 Kernel header를 인스톨 해야 할것 이다. 


/usr/src/kernels 디렉터리에 어떤 커널도 존재하지 않는다면, 
kernel-devel package를 설치하여 kerne header를 설치할 수 있다. 

~~~
yum install kernel-devel
~~~

설치가 완료 되었다면, 
~~~
ls -l /usr/src/kernels/$(uname -r)
~~~
로 설치된 Kernel Header를 확인할 수 있다.


또한, glibc의 사용이 필요할 경우, kernel-header 패키지를 설치하면 된다. 
~~~
yum install kernel-headers
~~~

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


make KSRC=/usr/src/linux-headers-4.9.2 all
make KSRC=/lib
~~~


## Makefile ##
Makefile (make용 Macro)에서 make 실행 명령어 부분의 앞은 TAB으로 구분/분리 해야 한다. 
ex) \t make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules


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




