

# 03. Application Debugger  #

## GDB (GNU Debugger) 개요 ##
- Strace 는 모니터링 대상의 System call 을 추적한다.
- ltrace는 모니터링 대상이 사용하는 library를 추적한다. 
- GDB는 Debugger이다. Windows의 Visual Studio 및 Eclipse에서의 Debugger mode를 생각하면 된다. 

## Application 구동 원리 ##
- Application 과 연관된 Troubleshooting을 위해서는 Application 구동 원리를 이해 해야 한다.
- 1) application Process 구동
- 2) Application Memory에 적재
- 3) Application 실행 명령어 
- process (kernel fork)
- file system (==> ELF, 라이브러리 적재,  code/text section)
- 언제나 유사한 형태의 메모리 유지 (관리가 쉬움 ) ==> 가상메모리 사용 (물리메모리 적재는 산발/복잡)
- micro-processor 명령어 셋 실행 => RIP => code section
- RIP 실행 중에, 점프 ==> 현재상태 저장하고 다른곳으로 ==> Stack
- RIP 실행 중에, memory 생성 ==> heap 생성/적재


## core dump ##
- core file을 남기도록 설정
<pre>
ulimit -a
ulimit -c unlimited
</pre>

## normal file( not seg fault )##
wget https://raw.githubusercontent.com/windflex-sjlee/linux_troubleshooting/master/src/test_011.c

<pre>
gcc -O0 -g -o test ./test_01.c
file core..
</pre>

## debugging ##

`gdb ./test`

<pre>
list main
bt
print a
print b
disas *main
b *main
</pre>

## seg fault ##
wget https://raw.githubusercontent.com/windflex-sjlee/linux_troubleshooting/master/src/test_01.c

`gdb ./test core xxx`

<pre>
list main
set listsize 50
bt
disp p
disas *main
b *main
info register   
</pre>

## backtrace example ##
wget https://raw.githubusercontent.com/windflex-sjlee/linux_troubleshooting/master/src/test_03.c
<pre>
bt
disas /m
info functions
</pre>

## 내부 debug용 소스파일 다운로드 #
debuginfo-install procps-ng

gdb /bin/free

## 기존 프로세스에 gdb attach ##

ps -ef | grep http

su -
sudo yum install -y httpd
rpm -qa httpd
    sudo service httpd start
systemctl start httpd

gdb -q -p 15004
 - q 옵션 : quite 

