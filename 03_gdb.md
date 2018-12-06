

# 03. Application Debugger  #

## GDB (GNU Debugger) 개요 ##
- Strace 는 모니터링 대상의 System call 을 추적한다.
- ltrace는 모니터링 대상이 사용하는 library를 추적한다. 
- GDB는 Debugger이다. Windows의 Visual Studio 및 Eclipse에서의 Debugger mode를 생각하면 된다. 

- core file
<pre>
ulimit -a
ulimit -c unlimited
</pre>

## not seg fault ##
wget https://raw.githubusercontent.com/windflex-sjlee/linux_troubleshooting/master/src/test_01.c

<pre>
gcc -O0 -g -o test ./test_01.c
file core..
</pre>

## debugging ##

gdb ./test

list main
bt
print a
print b
disas *main
b *main


## seg fault ##
wget https://raw.githubusercontent.com/windflex-sjlee/linux_troubleshooting/master/src/test_01.c
gdb ./test core xxx

list main
bt
disp p
disas *main
b *main


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

