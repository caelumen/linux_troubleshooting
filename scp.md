# SCP 사용법 #

## 원격 서버로 전송 ##

`scp 파일명 계정@서버주소:Path`

<pre>
scp a.txt appadmin@127.0.0.1:/home/appadmin
</pre>



## 원격 서버에서 가져오기 ##

### 기본 사용 ##
`scp 계정@서버주소:path 파일명`
<pre>
scp appadmin@127.0.0.1:/home/appadmin a.txt
</pre>

## options ##

### 포트 지정 ###
`scp -P 포트 계정@서버주소:path 파일명`

<pre>
scp -P 9022 appadmin@127.0.0.1:/home/appadmin a.txt
</pre>

### 디렉토리 전체 복사 ###
`scp -r 계정@서버주소:path 파일명`

<pre>
scp -r appadmin@127.0.0.1:/var/www/html /var/www/
</pre>


