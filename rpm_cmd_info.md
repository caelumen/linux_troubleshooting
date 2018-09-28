
https://www.lesstif.com/pages/viewpage.action?pageId=7635004


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


## 설치 / 업그레이드 ##
-ivh 옵션뒤에 설치할 패키지 파일명을 적어준다.
<pre>
<code>
rpm -ivh gzip-1.3.12-19.el6_4.x86_64.rpm
</code>
</pre>




