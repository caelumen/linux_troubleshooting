# [ GDB ] #

ulimit -a 
ulimit -c unlimited


# compile a source that make a fault intentionally
gcc -g -o test test_fault_01.c
./test


file core.*

gdb ./test core.*

where
bt
b *main
b 10
run
bt
info register
disas main




# apache service start


# attach debugger to  apache service
[ec2-user@ip-172-31-18-1 ~]$ ps -ef | grep http
# root      3750     1  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
# apache    3751  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
# apache    3752  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
# apache    3753  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
# apache    3754  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
# apache    3755  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
# apache    3801  3750  0 08:12 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND

sudo gdb -q -p 3750
generate-core-file
detach
q


set listsize 100



generate-core-file




