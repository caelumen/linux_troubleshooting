# GDB (GNU Debugger) - 디버깅  #

## GDB를 이용한 디버깅에 대한 간략한 소개 ##

### 1. 실행방법 ### 
~~~
 gdb [프로그램명]
 gdb [프로그램명] [core파일명]
 gdb [프로그램명] [실행중인프로세스pid]
~~~

### 2. 컴파일 옵션 ###
- GDB를 이용하여 디버깅 분석을 할 때, 컴파일 시 디버깅 정보를 포함하여야 디버깅 시 다양한 정보확인이 가능하다.
- 디버깅 옵션인 -g 으로 컴파일
- 최적화 옵션인 -O 은 주지 않음
~~~bash
$ gcc -g -o [프로그램명] [소스파일명]
~~~
 
###  3. 종료 ###
 - gdb prompt에서 `q`를 입력하거나, `Ctrl + d`를 입력하면 종료
 ~~~
 gdb> q
 ~~~
 
###  4. 소스찾아가기 (list) : GCC의 -g 옵션으로 컴파일 되어야 한다. ###
 - `l` : main 함수를 기준으로 소스 출력
 - `l 10` : 10번째 행 주션 소스 출력,  10행을 기준으료 +/- 5행씩 총 10행 출력
 - `l func` : func 함수의 소스 출력
 - `l test.c:func` : test.c 파일의 func 함수를 출력
 - `l test.c:10` : test.c 파일의 10행을 기준으로 출력
 
### 5. 프로그램 실행/종료 (run, kill) ###
- `r`   : 프로그램 실행 or 재시작
-  `r arg1 arg2` : arg1과 arg2를 인자로 실행
-  `k`   : 프로그램 종료

### 6. Backtrace ### 
- `bt` : 오류가 발생한 함수를 역추적, Call Strack을 출력한다.

### 7. Break Point ### 
- `b func`  : func 함수 break point 설정 
- `b 10`  : 10행에 break point 설정 
- `b a.c:func` : a.c파일의 func함수에 break point 설정 
- `b a.c:10` : a.c파일의 10행에 break point 설정 
- `b +2`  : 현재 행에서 2개 행 이후 라인에, break point 설정 
- `b -2`  : 현재 행에서 2개 행 이전 라인에, break point 설정 
- `b *0x8049000` : 0x8049000 주소에 break point 설정  (어셈블리로 디버깅 시 사용)
- `b 10 if var == 0` : 10행에 브레이크 포인트를 설정, 그러나 var 변수 값이 0일 때 한정 동작
- `tb`   : 임시 중단점을 사용. 한번만 동작하고 해제됨

###  8. Break Point 삭제 ### 
-  `cl func`  : func 함수에 지정된 Break Point 삭제
- `cl 10`  : 10행의 Break Point 삭제
- `delete 1` : 1번째 Break Point 삭제 
- `cl a.c:func` : a.c 파일의 func함수의 Break Point 삭제
- `cl`   : 모든 브레이크 포인트 삭제

### 9. Break Point 정보 확인  ### 
-`info b`  : 현재 Break Point 정보 보기
- `방향키Up/Down` : 방향키 Up/Down을 누르면 히스토리 기능

### 10. 디버깅 ### 
- step, next, continue, until, finish, return, step instruction, next instruction

| 명령어 |  설명                 |
|------  |-----------------|
| `s`    | step. 함수 내부로 들어가서 수행                |
| `s 5`  | step을 5회 진행               |
| `n`    | next. 함수 내부로 들어가지 않음                |
| `n 5`  | next 5회 실행                |
| `c`    | continue. 다음 Break Point까지 실행                |
| `u`    | for 문을 빠져 나와 다음 break point 까지 실행                |
| `finish` |  현재 함수 실행하고 함수를 빠져나감               |
| `return` |  현재 함수 실행X, 함수를 빠져나감               |
| `return 123` | 현재함수 실행X, 함수 빠져나감. return value 123                |
| `si`   | 현재 명령어 수행, 함수 내부 진입                |
| `ni`   | 현재 명령어 수행, 함수 내부 진입X                |

### 11. 모니터링 (watch) 및 변수 정보 확인 ### 
- `watch i` : 변수 i에 대하여 Watch. 변수i 값이 변경되면 값을 출력
- `info locals` : 현재 상태에서 지역변수 출력
- ` info variables` : 현재 상태에서의 전역변수 출력 
- ` p lval`  : print lval, lval 값을 확인한다.
- ` p func`  : func 함수의 주소값 확인
- ` p st`  : st가 구조체이면 구조체 주소 확인
- ` p *pt`  : pt가 구조체이면, 구조체의 값 확인
- ` p **pt`  : *pt가 구조체이면 구조체의 값을 확인
- ` info registers` : 레지스트 값 전체 확인 
- `p $eax`  : eax 레지스트의 값을 확인. (cf. ex_ eax, ebx, ecx, edx, eip ) 
- `p *pt@4`  : 4크기의 배열로 gdb가 알 수 있으므로 4개의 크기만큼 가져와서 확인
- `p[출력형식] [변수명]` : 변수를 옵션에 따라 출력
   - [출력형식] : /t : 2진수, /o : 8진수, /d : 10진수, /u : 10진수(unsigned), /x : 16진수, /c : character형, /f : float
   - ex) `p/x a` : 변수a를 16진수로 출력
- `p [함수명]@[배열크기]` : 변수의 내용을 배열크기 형태로 출력
- 캐스팅 : `p (char*)a` 

### 12. 변수값 설정 ### 
 - p lval = 1000 : 변수값 설정
 
###  13. 스택 ### 
- 스택의 상위 1기가는 커널이 사용, 그 아래 공간인  상위 0xBFFFFFFF 부터 하위로 늘어남
- `frame [N]` : N번 스택 프레임으로 변경
- `info frame` : 현재 스택 프레임 정보 출력
- `info args` : 현재 스택 프레임의 함수가 호출될 때, 인자를 출력


### 14. 메모리 상태 검사 (x) ### 
- `x/[범위][출력형식][범위의 단위]` : 메모리의 특정 범위의 값 확인
- `x/10 main` : main 함수에서부터 40바이트 출력
  - `x/10t main` : 2진수
  - `x/10x main` : 16진수 출력,  x/10o, x/10d, x/10u, x/10c 등 
- x/10w main : 범위의 단위 (word - 4byte) 출력.  word단위 x 10 = 40바이트 출력
- x/10b main : byte 단위 10개, 10바이트 출력.

### 15. 디스어셈블 (disas) ### 
- `disas func` : 어셈블리 
- `disas 0x8048300 0x8048400` : 특정 주소 범위사이의 어셈블코드

 
### 기타 옵션 (options) ###

- `set listsize 20` : list 한번에 출력하는 행의 갯수를 20으로 설정 
- `<enter>` : 마지막으로 수행한 명령어 다시 수행


