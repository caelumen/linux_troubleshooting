
# AWS SSH 실습 답안 #

1. AWS에 Linux 자원 (Server instance) 만들것
 - 자체 진행
 
2. AWS에 접속하여 신규 계정 (ex. student)를 만들것

- AWS Server에서, sutdent 계정을 생성한다.
<pre>
[AWS student ~]$ sudo adduser student
[AWS student ~]$ sudo passwd student
[AWS student ~]$ su - student
</pre>

3. 신규계정으로 SSH에 접속할 수 있도록 환경 구성 할것

<pre>
[AWS student ~]$ mkdir .ssh
[AWS student ~]$ chmod 700 .ssh
[AWS student ~]$ touch .ssh/authorized_keys
[AWS student ~]$ chmod 600 .ssh/authorized_keys
</pre>
-  ※ 중요 : 파일권한이 과다하면 접속할 수 없다.

4. VM Cluster 1에서 AWS의 신규 계정으로 접속 할것
 - VM Cluster 1에서 진행, AWS 서버에서 진행도 가능하나, key file 옮기기가 번거로움
 
<pre>
[clu_1 ~]$ cd ~/.ssh
[clu_1 ~]$ ssh-keygen -y
[clu_1 ~]$ vi id_rsa.pub
</pre>

5. AWS의 환경 세팅 (다시)
- 퍼블릭키 (id_rsa.pub) 복사 (VM Clu_1에서)
- AWS 서버로 이동하여, 
<pre>
[AWS student ~]$ vi authorized_keys
</pre>
- 복사한 클립보드 (퍼블릭키) 붙여 넣기

* .ssh 와 .id_rsa , authorized_keys 의 권한이 적절하지 않은 경우 접속 되지 않음
-  .ssh 는 서버와 클라이언트 모두 권한 체크 필요
- authorized_keys는 서버쪽에 권한 체크 필요
