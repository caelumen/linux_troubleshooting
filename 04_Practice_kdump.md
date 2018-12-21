# <lab 04> 

미리 준비되어 있는 vmlinux (kernel 2.6 환경), vmcore를 사용하여 crash 분석을 진행한다.


```bash
[root@clu_1 vmcore]# crash 2.6.32-504.el6.x86_64/vmlinux 504vmcore/vmcore
```


만약 파일일 없을 경우 아래 경로에서 다운로드 할 수 있다.
> vmcore : https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmcore
> vmlinux : https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmlinux

### vmlinux와 vmcore 파일을 확보하였으면, Crash를 실행하여 분석 해 보자
~~~bash
sys
kmem -i
ps
ps | grep -c RU
sys | grep LOAD
ps | wc -l
ps | grep -c httpd
ps | grep -c java
~~~
