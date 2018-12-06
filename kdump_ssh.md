# Remote Dump to Clu_2:/var/crash #
~~~
[root@clu_1 ~]#  ssh clu_2

[root@clu_2 .ssh]# ssh-keygen
[root@clu_2 .ssh]# exit

[root@clu_1 ~]#  scp clu_2:/root/.ssh/id_rsa* .
~~~

`vi /etc/kdump.conf`
~~~
ssh root@clu_2
sshkey /root/.ssh/id_rsa
~~~

- `kdumpctl propagate`
~~~
[root@clu_1 ~]# kdumpctl propagate
Using existing keys...
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: WARNING: All keys were skipped because they already exist on the remote system.
/root/.ssh/id_rsa has been added to ~root/.ssh/authorized_keys on clu_2
~~~

- 리부팅하여 kdump 다시 적용
`systemctl reboot`
