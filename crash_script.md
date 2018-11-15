[ Crash ]

## vmcore
https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmcore

## vmlinux
https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmlinux


sudo crash vmlinux vmcore
 - PANIC: "Kernel panic - not syncing: Out of memory: system-wide panic_on_oom is enabled"

crash> log



=========================================================================
# 주요 명령어
=========================================================================

- sys - 시스템의 일반적인 정보를 출력해 준다.
- bt - Backtrace 명령. 스택의 내용들을 순차적으로 출력해준다.
- ps - Process list 출력.
- free - Memory 및 스왑 상태 출력.
- mount - 마운트 상태 출력
- irq - 각 장치의 ( irq ) 상태를 출력.
- kmem - 메모리 상태 출력 ( kmalloc, valloc 등 메모리 할당 상태도 보여줌 )
- log - dmesg 의 내용을 출력.
- mod - 로딩된 모듈 리스트 출력.
- net - Network 상태 출력.
- runq - 실행중인 task 리스트 출력.
- task - 작업목록 출력.
- rd - 메모리 번지수에 대한 상세정보 출력.
- foreach - 모든 task, process 등 디버깅 정보에 대한 상세한 출력이 가능함.
- set - 설정된 주소 및 PID 등을 기본 컨텍스트로 설정.
- struct - 구조화된 메모리 내부의 변수들을 출력해 준다.
- files - task 가 열고있는 파일디스크립터들을 출력해준다


=========================================================================
# 주요 분석 순서
=========================================================================

- 1. debug info 로 부터 vmlinux 추출
- 2. CRASH tools 을 이용한 corefile 과 vmlinux 로드.
- 3. 커널 로그 확인.
- 4. 메모리 상태 확인.
- 5. backtrace 를 통한 최종 stack 내용 확인
- 6. 최종 스택의 Return Address 의 내용을 Code 또는 Dis-Assembly 를 통해 확인.
- 7. 버그 정보 검색.
- 8. 버그일 경우 해당 패치정보 검색.
- 9. 알려지지 않은 버그일 경우 해당 벤더에 버그 오픈 또는 Advanced 분석 요청.
- ** 대부분의 커널 버그는 잘 알려져 있는 버그. 
