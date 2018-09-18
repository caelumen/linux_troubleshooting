# [ GDB ] #

ulimit -a 
ulimit -c unlimited

sudo su
ulimit -c unlimited
exit

# compile a source that make a fault intentionally
gcc -g -o test test_fault_01.c






