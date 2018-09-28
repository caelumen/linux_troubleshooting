


# RPM 주요 명령어 #

## 주요 명령어 ##

| 옵션  |  설명   | 
|---|---|  
|-q	|--query	패키지 정보 질의 |  
|-i	|--install	패키지 설치 |  
|-U	|--upgrade	패키지 업그레이드 |  
|-e	|--erase	패키지 삭제 |  
|-V	|--verify	패키지 검증 |  
|-K	|--checksig	서명 검증 |  



## 기본 옵션 ##
-?, --help : 도움말 출력
--version : rpm 버전 출력
-v : 자세한 정보 출력
-vv : 디버깅용 정보 출력
--dbpath DIRECTORY_PATH: rpm 데이타베이스 파일 경로 설정. 기본 경로는 /var/lib/rpm 
--root DIRECTORY_PATH: 파일 시스템의 루트 디렉터리 경로 설정. rpm 을 사용자 디렉터리에 설치했을 경우등에 유용함. 기본 경로는 /
--pipe CMD: rpm 명령어의 출력을 CMD 명령어로 전송


## 설치 ##
-ivh 옵션뒤에 설치할 패키지 파일명을 적어준다.
<pre>
rpm -ivh gzip-1.3.12-19.el6_4.x86_64.rpm
rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/gzip-1.3.12-19.el6_4.x86_64.rpm
</pre>

## 업그레이드 ##
기존에 설치된 package를 업그레이드
<pre>
rpm -Uvh my-package.rpm
</pre>



# RPM Query #

## 전체 설치 패키지 보기 ##
<pre>
rpm -qa | less
</pre>

## 자세한 정보 보기 ##
패키지 용도, 라이선스, 홈페이지등 추가 information (-i 옵션)
<pre>
rpm -qi httpd
rpm -qpi httpd
</pre>


## 파일이 속한 패키지 알기 ##
<pre>
rpm -qf `which httpd`
rpm -qdf `which httpd`  
</pre>


## 설치 경로 보기 ##
패키지내 어떤 파일이 어디에 설치되어있는지는 -l (--list)옵션 추가함
<pre>
rpm -ql httpd
</pre>


## 문서 파일 목록 보기 ##
<pre>
pm -qd httpd  
</pre>

## 설정파일 목록 보기 ##

<pre>
rpm -qc httpd 
</pre>







참조처 : https://www.lesstif.com/pages/viewpage.action?pageId=7635004

