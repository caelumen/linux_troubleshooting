# sudoer 등록 #

## SUDO 명령어
 - sudo 명령어는 일시적으로 root 권한을 부여하여 실행하도록 하는 명령어 이다. 
 - super user로 do (실행) 이라는 의미

## SUDO 사용자 전환 ##
 - 일반 계정이 모두 sudo를 사용할 수 있는 것은 아니고, SUDOERS로 등록되어 있어야만 sudo 사용이 가능하다. 
 - sudo에 대한 권한 설정은 /etc/sudoers  에 기록되어 있다. 
 
 보안을 위해서 기본적으로 쓰기 권한은 배제되어 있다. 
 <pre>
 
 </pre>

# 흔한 착각 1 #
 - sudo 명령어를 사용할 때, 입력을 요구하는 password는 root의 password가 아니라, sudoer에 등록된 사용자의 password이다. 
 - 즉, sudoer로 등록된 사용자 자체가 root의 권한을 행사 할 수 있다. 
 - 단지, root에 준하는 명령어를 실행할 때, 한번 더 절차를 거칠 뿐이다. 

# 특정 사용자 or 그룹에 Sudo를 권한 부여 #


# Password 없이 sudo를 사용 #









