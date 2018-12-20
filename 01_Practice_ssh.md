# 실습 문제 #


## 실습 목표
- SSH 메커니즘을 이해한다.
- SSH의 접속 설정을 이해한다. 
- SSH 접속이 안될 경우를 파악한다.
- SSH 접속이 안될 경우 문제 해결한다. 


# 문제 1.
SSH Public Key를 이용하여 테스트 서버에 접속 해 본다.
  - clinet : 각자의 clu_1 vm linux
  - server ip : 172.23.192.139 (변경 가능)
  - port : 9022
  - private key : wget https://raw.githubusercontent.com/windflex-sjlee/linux_troubleshooting/master/keys/id_rsa

> password 입력으로 로그인 되지 않음

### ssh 명령어는 아래를 참조 한다. 
```bash
ssh -i <private key> <계정명>@<ip주소> -p <포트no>
```

### 예상 에러 1.
```bash
Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```

### 예상 에러 2.
```bash
[root@clu_1 key2]# ssh -i id_rsa root@172.23.192.139 -p 9022
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```
> 위와 같은 현상 발생은 Permission의 문제 이다. 


# 문제2.
## node2에 SSH를 만들고, 주어진 Key_pair로 접속할 수 있게 구성


```bash
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

RSAAuthentication yes
PubkeyAuthentication yes

AuthorizedKeysFile      .ssh/authorized_keys

PasswordAuthentication no
```
> `/etc/ssh/sshd_config` 설정 중 위 항목  참고


# 문제 3. AWS 환경에서 SSH 구성
- AWS에서 Linux (Amazon Linux2) 서버 자원 구성
- AWS의 Key Pair를 변경해서 접속해 볼것
- 신규 계정 (ex. student)를 만들어 SSH 접속 환경을 구성할 것
> AWS는 key pair를 보관하지 않는다.
> authorized_keys는 계정마다 개별 적용됨


## 문제 4. Cluster 1 VM에서 AWS로 접속 해 볼것
- 최종적으로, 실습 VM인 Cluster 1에서 AWS로 접속 해 볼것
> key file 복사가 필요. key file 복사과정에서 실수 발생 가능성 높음에 주의





