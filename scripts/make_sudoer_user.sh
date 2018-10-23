#!/bin/bash
username=$(whoami)   # 변수선언시 띄어쓰기가 중요하다.

if [ $# -lt 1 ]
then
   echo "make_sudoer <new username> <new password>"
   exit 0
fi

if [ "$username" == "root" ]  # 띄어쓰기 유의하라. 숫자비교와 스트링 비교는 다르다.
then


adduser $1
passwd $2
cat /etc/passwd | grep $1
cat /etc/group | grep $1
usermod -aG wheel $1
cat /etc/group | grep $1
su $1
id
chk_result=sudo cat /etc/shadow | grep $1 | w -l

  if [ "$chk_result" -gt 2 ]
  then
    echo "#user=$chk_result"
    echo "process complete..!"
  fi
else
  echo "permission dennied"
fi
