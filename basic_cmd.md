

# Find 파일검색# 


* 기본사용법

find [검색대상위치] [옵션] [수행할작업]



* 생성한지 하루가 지난 tmp 폴더에 있는 세션파일 한번에 삭제

find -name 'sess_*' -ctime +1 -exec rm -rf {} \;



* 특정 소유자의 파일 검색

find -user username -print

find -user username -exec ls -lh {} \;



* 파일 개수 세기

find 경로 -type f | wc -l




*****

# SCP 파일 전송 #
[SCP 파일전송 사용법]

* 다른 서버로 파일 복사해서 보내기
# scp 보낼파일 root@서버IP:타겟경로



* 다른 서버에서 파일 복사해서 가져오기
# scp root@서버ip:파일경로 타겟경로



* 다른 서버에서 디렉토리 복사해서 가져오기
# scp -rp root@서버ip:디렉토리 타겟경로



* 옵션
-r : 리커시브
-v : 상세한 진행사항을 봄
-F ssh_config : 지정한 설정파일을 사용
-P port : 지정한 포트로 접속시도
-p : 원본파일 수정/사용시간 및 권한을 유지
