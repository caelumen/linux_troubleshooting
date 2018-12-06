

# 03. gdb #

## GDB 개요 ##

- core file
<pre>
ulimit -a
ulimit -c unlimited
</pre>

## not seg fault ##
wget https://raw.githubusercontent.com/windflex-sjlee/linux_troubleshooting/master/src/test_01.c

gcc -O0 -g -o test ./test_01.c
file core..

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

