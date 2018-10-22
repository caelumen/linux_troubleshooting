# sudoers 등록하기 
 - /etc/sudoers 파일에 바로 개별 user를 등록할 수도 있으나, 
 - 일반적으로 이렇게 하지 않고, 그룹을 추가한다. 
 - wheel 그룹에 사용자를 추가하고, wheel 그룹을 sudoers에 포함시킨다. 

# wheel , wheel Group 이란?

특별 시스템 권한이 부가되는, 휠 비트를 가진 사용자 계정
(휠 그룹) su 명령어를 사용하여 다른 사용자 계정에 접근할 수 있는 계정그룹



# 새로운 user를 sudoer로 추가하기

1) root user로 로그인

useradd test_user
passwd test_user


2) visudo

  ==> /etc/sudoers 파일 수정. 쓰기권한이 제거되어 있기 때문에 별도 명령어로 만들어져 있다.
      chmod u+w /etc/sudoers , vi /etc/sudoers, chmod u-w /etc/sudoers 를 하나로 만들어 놓은것이다
3) /etc/sudoers 내용 수정
wheel 그룹 사용이 주석처리 되어 있으면 주석을 해제 한다. 

## Allows people in group wheel to run all commands
# %wheel        ALL=(ALL)       ALL

==> 
%wheel        ALL=(ALL)       ALL   

저장 후 나온다.

4) 확인

su test_user - 
sudo whoami
groups



※ bash에서 exit를 해서 원래 계정으로 돌아간뒤 테스트를 하면,
   다시 접속 전까지 bash가 그룹변환을 인지 못할 수도 있다. 




