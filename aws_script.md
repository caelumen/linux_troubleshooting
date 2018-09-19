# [ AWS ]
# 강의 자료 [강의자료] : https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/docs/(Day3)Linux_TroubleShooting_v0.7.pptx

- https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/putty.exe
- https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/puttygen.exe
- https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmcore
- https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmlinux


# 1. SSH 맛보기 #
 - 아직 미공개
 - https://s3.ap-northeast-2.amazonaws.com/windflex/test_key/test_key_share.pem
 - ssh -i test_key_share.pem ec2-user@13.124.162.236

# 2. AWS 설치 #
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


# 3. Git-bash / terminal 접속 #
<pre>
ssh -i test_key_share.pem ec2-user@13.124.162.236
</pre>

# 4. apache 설치 #
<pre>
sudo yum update –y 
sudo yum install –y httpd 
sudo service httpd start 
</pre>
![아파치 테스트 화면](https://mblogthumb-phinf.pstatic.net/MjAxNjExMDhfNDEg/MDAxNDc4NTYzNzMyMjQ3.PqaY6ZTLGl_KFLfdZyyYNnx_mpYlUQmQNVXoOCb3PKcg.5pYlKyUR4nr0F1pYeRNngKBMrkxbI1-ytke6xyPXx1sg.JPEG.wizardkyn/httpd_RHEL72.JPG?type=w2)


------------------------------------------

# 5. 다시 SSH #
![SSH](http://www.fs.com/images/ckfinder/ftp_images/tutorial/secure-ssh-client.jpg)
- SSH 암호화 방식

## AWS EC2 => Putty 사용 ##
![putty](http://www.fs.com/images/ckfinder/ftp_images/tutorial/putty.jpg)
 - PuTTYgen을 사용하여 프라이빗 키 변환
 - 개인 키를 변환하려면,
 - PuTTYgen을 시작합니다(예: [Start] 메뉴에서 [All Programs > PuTTY > PuTTYgen] 선택).
   Type of key to generate에서 RSA를 선택합니다.

## ssh key 관련 파일 
<pre>
cd ~/.ssh
ls -al 
</pre>

|파일  | 내용 | 위치    |
|------|-----|-----|
|id_rsa      | private key    |  client    |
|id_rsa.pub  | public key  | client    |
|authorized_keys  | public key, 접속할 때, id_rsa에서 가져와 저장  |  remote server   |
|known_hosts |  처음 접속할 때, yes/no에 따라 known hosts에 등록 | client |

** knwon_host에 아래처럼 등록 된다. 
<pre>
ec2-13-xxx-xxx-xxx.ap-northeast-2.compute.amazonaws.com,111.111.111.xxx ssh-rsa AAAAB3NzaC...D0AV
</pre>

# 6. SSH key Error 발생 !! #


# 6. SSH Key 변경 #
================================================

<pre>
cd ~/.ssh
sudo vi .ssh/authorized_keys
</pre>

* 키값 변경 : ssh-rsa [AAAAB===>키값==>Mab1] key_name_public
- 제대로 변경이 되었는지, scp로 접속해 보자!!!


# 정확한 Private-Public Key를 대입하여도, 접속 불가
 - SCP를 이용하여, AWS에 key를 복사
 - ssh -i test_key_share.pem  ec2-user@172.31.18.1
 - ==> unprotected !!!!


# SSH-KEYGEN
 - ssh-keygen -t rsa



