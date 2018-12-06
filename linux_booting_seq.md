# Linux Booting Sequence #

1) BIOS가 시스템 이상 여부 테스트 -> 부트로더에서 수행
2) 부팅할 드라이브 선택 -> 커널의 플래쉬 위치 선택
3) 선택된 드라이브의 MBR읽어 드림 ->수행 불필요
4) MBR의 파티션 테이블을 읽어 부팅할 파티션을 선택 -> 수행 불필요
5) 커널 로드 -> 커널을 램상으로 복사
6) 커널 압축 해제/ 재배치
7) 장착된 하드웨어 검사, 장치 드라이버 설정
8) 파일 시스템 검사 -> 램디스크, jffs이미지에 포함
9) 파일 시스템 마운트
10) /etc/inittab에서 init실행을 위한 설정 내용 확인
11) /sbin/init 실행(PID가 1이됨)
12) /etc/rc.d/rc.sysinit실행(hostname,시스템 점검, 모듈 로딩)
13) /etc/rc.d/rc실행 (runlevel에 따른 스크립트 실행)
14) /etc/rc.d/rc.local(매번 실행할 내용 입력)
15) /etc/rc.d/rc.serial (시리얼 포트 초기화)
16) login
