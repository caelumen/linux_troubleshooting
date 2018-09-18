[ Crash ]

## vmcore
https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmcore

## vmlinux
https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmlinux


sudo crash vmlinux vmcore
 - PANIC: "Kernel panic - not syncing: Out of memory: system-wide panic_on_oom is enabled"

crash> log



#=========================================================================
* �ֿ� ��ɾ�
#=========================================================================

sys - �ý����� �Ϲ����� ������ ����� �ش�.
bt - Backtrace ���. ������ ������� ���������� ������ش�.
ps - Process list ���.
free - Memory �� ���� ���� ���.
mount - ����Ʈ ���� ���
irq - �� ��ġ�� ( irq ) ���¸� ���.
kmem - �޸� ���� ��� ( kmalloc, valloc �� �޸� �Ҵ� ���µ� ������ )
log - dmesg �� ������ ���.
mod - �ε��� ��� ����Ʈ ���.
net - Network ���� ���.
runq - �������� task ����Ʈ ���.
task - �۾���� ���.
rd - �޸� �������� ���� ������ ���.
foreach - ��� task, process �� ����� ������ ���� ���� ����� ������.
set - ������ �ּ� �� PID ���� �⺻ ���ؽ�Ʈ�� ����.
struct - ����ȭ�� �޸� ������ �������� ����� �ش�.
files - task �� �����ִ� ���ϵ�ũ���͵��� ������ش�


#=========================================================================
* �ֿ� ��ɾ�
#=========================================================================

1. debug info �� ���� vmlinux ����
2. CRASH tools �� �̿��� corefile �� vmlinux �ε�.
3. Ŀ�� �α� Ȯ��.
4. �޸� ���� Ȯ��.
5. backtrace �� ���� ���� stack ���� Ȯ��
6. ���� ������ Return Address �� ������ Code �Ǵ� Dis-Assembly �� ���� Ȯ��.
7. ���� ���� �˻�.
8. ������ ��� �ش� ��ġ���� �˻�.
9. �˷����� ���� ������ ��� �ش� ������ ���� ���� �Ǵ� Advanced �м� ��û.
** ��κ��� Ŀ�� ���״� �� �˷��� �ִ� ����. 
