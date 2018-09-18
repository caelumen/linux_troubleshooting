# [ AWS ]

- https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/putty.exe
- https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/puttygen.exe
- https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmcore
- https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmlinux


# SSH 맛보기 #
 - 아직 미공개
 - https://s3.ap-northeast-2.amazonaws.com/windflex/test_key/test_key_share.pem
 - ssh -i test_key_share.pem ec2-user@13.124.162.236

# AWS 설치 #
![AWS 가입 및 설치]https://aws.amazon.com/ko/
- AWS 가입이 완료되면, EC2의 인스턴스 생성
- Key Pair 확보, Private Key 중요 !!!


# 참고 - default user
| 배포판 | 기본 사용자 이름|
|---|---|
| Amazon Linux 2 or 1  |  ec2-user  |
| Centos AMI                           |  centos |
| Debian AMI   | admin 또는 root |
| Fedora AMI | ec2-user 또는 fedora |
| RHEL AMI | ec2-user 또는 root |
| SUSE AMI | ec2-user 또는 root |
| Ubuntu AMI | ubuntu |




# AWS EC2 => Putty 사용 
 - PuTTYgen을 사용하여 프라이빗 키 변환
 - 개인 키를 변환하려면,
 - PuTTYgen을 시작합니다(예: [Start] 메뉴에서 [All Programs > PuTTY > PuTTYgen] 선택).
   Type of key to generate에서 RSA를 선택합니다.



==============================================
# SSH Key 변경
================================================


> cd .ssh
> sudo vi .ssh/authorized_keys
>
* 키값 변경 : ssh-rsa [AAAAB===>키값==>Mab1] key_name_public
- 잘변경이 되었는지, scp로 접속해 보자!!!



# 정확한 Private-Public Key를 대입하여도, 접속 불가
 - SCP를 이용하여, AWS에 key를 복사
 - ssh -i test_key_share.pem  ec2-user@172.31.18.1
 - ==> unprotected !!!!


# SSH-KEYGEN
 - ssh-keygen -t rsa



