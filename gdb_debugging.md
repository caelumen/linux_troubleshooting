# [GDB 디버깅 ] #

1. 우선 컴파일 시에 디버깅 정보를 담아야 한다.
 gcc -g -o [프로그램명] [소스파일명]
 디버깅 옵션인 -g 으로 컴파일하며, 최적화 옵션인 -O 은 주지 않도록 한다.

2. 실행방법
 gdb [프로그램명]
 gdb [프로그램명] [core파일명]
 gdb [프로그램명] [실행중인프로세스pid]

3. 종료방법
 q
 Ctrl + d

4. 소스 찾아가기 (list)
 l   : main 함수를 기점으로 소스의 내용이 출력된다
 l 10  : 10 행 주변의 소스가 출력되는데 10 - 5 행부터 10 + 5행까지 총 10행이 출려된다.
 l func  : func 함수의 소스를 출력
 l -5  : 기본값으로 10줄이 출력된다고 가정하고, 다음에 출력될 라인이 11라인이라면, 10(마지막라인) - 5 라인을 중심으로 출력된다. 즉, 그대로 1~10라인이 출력된다.
 l a.c:func : a.c 파일의 func 함수부분을 출력
 l a.c:10 : a.c 파일의 10행을 기준으로 출력

5. 옵션
 set listsize 20 : 한번에 출력하는 행의 갯수를 20개로 늘린다.
 Enter  : 마지막으로 수행한 명령어를 다시 수행한다

6. 프로그램 실행, 종료 (run, kill)
 r   : 프로그램 수행 (재시작)
 r arg1 arg2 : arg1과 arg2를 인자로 프로그램 수행
 k   : 프로그램 수행종료

7. 역추적하기 (backtrace)
 bt   : 오류가 발생한 함수를 역으로 찾아간다.

8. 중단점 사용하기 (breakpoint, temporary breakpoint)
 b func  : func 함수에 브레이크 포인트 설정
 b 10  : 10행에 브레이크 포인트 설정
 b a.c:func : a.c파일의 func함수에 브레이크 포인트 설정
 b a.c:10 : a.c파일의 10행에 브레이크 포인트 설정
 b +2  : 현재 행에서 2개 행 이후 지점에 브레이크 포인트 설정
 b -2  : 현재 행에서 2개 행 이전 지점에 브레이크 포인트 설정
 b *0x8049000 : 0x8049000 주소에 브레이크 포인트 설정 (어셈블리로 디버깅 시 사용)
 b 10 if var == 0 : 10행에 브레이크 포인트를 설정해되, var 변수 값이 0일 때 작동
 tb   : 임시 중단점을 사용하는 것으로 한번만 설정되며, 그 이후에는 삭제된다.

9. 중단점 설정하기 (condition)
 condition 2 var == 0 : 고유번호가 2번인 브레이크포인트에 var변수가 0일 때 동작하라고 설정

10. 중단점 삭제하기 (clear, delete)
 cl func  : func 함수의 시작 부분에 브레이크 포인트 지움
 cl 10  : 10행의 브레이크 포인트 지움
 delete 1 : 고유번호 1번의 브레이크 포인트를 지운
 cl a.c:func : a.c 파일의 func함수의 브레이크 포인트 지움
 cl a.c:10 : a.c 파일의 10행의 브레이크 포인트 지움
 cl   : 모든 브레이크 포인트 지움 
11. 중단점 정보보기 (information)
 info b  : 현재 설정된 브레이크 포인트의 정보를 보여준다
 방향키Up/Down : 방향키 Up/Down을 누르면 히스토리 기능을 제공한다
 info br + TAB : info br 로 시작하는 키워드가 히스토리에 있다면 뿌려준다
 info TAB + TAB : info 뒤에 올 수 있는 인자 리스트를 보여준다
 TAB + TAB  : 현재 사용가능한 모든 명령어 리스트를 보여준다

12. 중단점 비활성화, 활성화 하기 (enable, disable)
 disable 2 : 고유번호 2번인 브레이크 포인트 비활성화
 enable 2 : 고유번호 2번인 브레이크 포인트 활성화

13. 디버깅 하기 (step, next, continue, until, finish, return, step instruction, next instruction)
 s  : 현재 출력된 행을 수행하고 멈추지만, 함수의 경우 함수의 내부로 들어가서 수행된다
 s 5  : s를 5번 입력한 것과 동일
 n  : 현재 행을 수행하고 멈추지만, 함수의 경우 함수를 수행하고 넘어간다
 n 5  : n을 5번 입력한 것과 동일
 c  : 다음 브레이크 포인트를 만날때 까지 계속 수행한다
 u  : for 문에서 빠져나와서 다음 브레이크 포인트까지 수행한다.
 finish : 현재 함수를 수행하고 빠져나감
 return : 현재 함수를 수행하지 않고 빠져나감
 return 123 : 현재 함수를 수행하지 않고 빠져나감, 단, 리턴값은 123
 si  : 현재의 인스트럭션을 수행, 함수 호출 시 내부로 들어간다.
 ni  : 현재의 인스트럭션을 수행, 함수 호출 시 내부로 들어가지 않는다.

14. 감시점 설정 (watch)
 watch i : i변수에 와치포인트를 설정하고 i변수가 바뀔 때마다 브레이크가 걸리면서 이전값과 현재값을 출력한다.

15. 변수 정보보기 (info, print)
 info locals : 현재 상태에서 어떤 지역변수들이 있으며, 값은 어떠한지를 알 수 있다.
 info variables : 현재 상태에서의 전역변수 리스트를 확인할 수 있다.
 p lval  : lval 값을 확인한다.
 p func  : func 함수의 주소값을 확인한다.
 p pt  : pt가 구조체라면 구조체의 주소를 확인한다
 p *pt  : pt가 구조체라면 구조체의 값을 확인한다.
 p **pt  : *pt가 구조체라면 구조체의 값을 확인한다.
 info registers : 레지스트 값 전체를 한번에 확인한다.

16. 레지스트 값 및 포인터가 가리키는 구조체의 배열을 출력 (info, print)
 info all-registers : MMX 레지스트를포함하여 거의 대부분의 레지스트 값을 확인한다.
 p $eax  : eax 레지스트의 값을 확인한다. ( ex_ eax, ebx, ecx, edx, eip ) 
 p *pt@4  : 4크기의 배열로 gdb가 알 수 있으므로 4개의 크기만큼 가져와서 확인할 수 있다.

17. 중복된 변수명이 있는 경우 특정 변수를 지정해서 출력 (print)
 p 'main.c'::var : main.c 파일에 있는 전역변수인 var 변수의 값을 출력
 p hello::var : hello 함수에 포함된 static 변수인 var 변수의 값을 출력

18. 출력 형식의 지정
 p/t var : var 변수를 2진수로 출력
 p/o var : var 변수를 8진수로 출력
 p/d var : var 변수를 부호가 있는 10진수로 출력 (int)
 p/u var : var 변수를 부호가 없는 10진수로 출력 (unsigned int)
 p/x var : var 변수를 16진수로 출력
 p/c var : var 변수를 최초 1바이트 값을 문자형으로 출력
 p/f var : var 변수를 부동 소수점 값 형식으로 출력
 p/a addr : addr주소와 가장 가까운 심볼의 오프셋을 출력 ( ex_ main + 15 )

19. 타입이 틀릴 경우 타입을 변환하여 출력
 p (char*)vstr : 실제 컴파일 시에 (void *)형으로 되어있었다고 하더라도 (char *)로 캐스팅 하여 보여줌

20. 특정한 위치 지정
 p lstr + 4 : 예를 들어 lstr = "I like you." 라는 문자열은 "ke you."가 출력된다.

21. 변수 값 설정
 p lval = 1000 : 변수값 확인 이외에는 설정도 가능하다.

22. 출력명령 요약 (print)
 p [변수명]    : 변수 값을 출력
 p [함수명]    : 함수의 주소를 출력
 p/[출력형식] [변수명] : 변수 값을 출력 형식으로 출력
 p '[파일명]'::[변수명] : 파일명에 있는 전역변수 값을 출력
 p [함수명]::[변수명] : 함수에 있는 변수 값을 출력
 p [변수명]@[배열크기] : 변수의 내용을 변수 배열의 크기 형태로 출력

23. 디스플레이 명령 (display, undisplay)
 display [변수명]  : 변수 값을 매번 화면에 디스플레이
 display/[출력형식] [변수명] : 변수 값을 출력 형식으로 디스플레이
 undisplay [디스플레이번호] : 디스플레이 설정을 없앤다
 disable display [디스플레이번호] : 디스플레이를 일시 중단한다.
 enable display [디스플레이번호] : 디스플레이를 다시 활성화한다.

24. 스택이란
 스택의 경우는 상위 1기가는 커널에서 사용하며, 그 바로 아래 공간인 상위 0xBFFFFFFF 부터 하위로 늘어나게된다.
 상세한 디버깅을 위해서는 -g 옵션으로 디버깅 정보와 --save-temps 옵션을 통해 어셈블리 코드를 얻어낼 수 있다.
 상위 프레임으로 갈 수록 메인 함수에 가까워 지는 것이다.

25. 스택 프레임 관련 명령 (frame, up, down, info)
 frame [N] : n번 스택 프레임으로 변경
 up   : 상위 프레임으로 이동
 up [N]  : n번 상위 스택 프레임으로 이동
 down  : 하위 프레임으로 이동
 down [N] : n번 하위 스택 프레임으로 이동
 info frame : 현재 스택 프레임 정보를 출력
 info args : 현재 스택 프레임의 함수가 호출될 때 인자를 출력
 info locals : 현재 스택 프레임의 함수내의 지역변수를 출력
 info catch : 현재 스택 프레임의 함수내의 예외 핸들러를 출력

26. 스택 트레이스 하는법
 b main 또는 원하는 곳에 브레이크 포인트를 잡고
 오류가 발생할 때 까지 c를 통해 진행하면, 세그먼트 폴트 등의 오류가 발생하고 디버그가 멈추는데
 여기서 bt 를 통해서 전체 스택 프레임을 확인하고 어떤 함수에서 호출시에 문제가 발생하였는지 확인
 단, 일반적인 라이브러리에서는 오류발생 확률이 없다고 보고, 그 함수를 호출시에 문제를 의심한다.
 다시 프레임을 이동하면서, 로컬변수와 전역변수 등을 확인하면서 디버깅이 가능하다.

27. 메모리 상태 검사 (x)
 x/[범위][출력 형식][범위의 단위] : 메모리의 특정 범위의 값들을 확인할 수 있다.
 이렇게 메모리를 직접 읽어보는 일은 -g 옵션을 가지고 컴파일 되지 않은 실행파일을 디버깅 할때에 자주 사용된다.
 즉, x/10i main 과 같이 역 어셈블하여 해당 코드를 추측하는 것이다.

28. 출력형식
 x/10 main : main 함수 시작부터 40바이트를 출력한다. 출력형식은 다음과 같다.
 x/10t main : main 함수 시작부터 40바이트를 2진수로 출력
 x/10o main : main 함수 시작부터 40바이트를 8진수로 출력
 x/10d main : main 함수 시작부터 40바이트를 부호가 있는 10진수로 출력 (int)
 x/10u main : main 함수 시작부터 40바이트를 부호가 없는 10진수로 출력 (unsigned int)
 x/10x main : main 함수 시작부터 40바이트를 16진수로 출력
 x/10c main : main 함수 시작부터 40바이트를 최초 1바이트 값을 문자형으로 출력
 x/10f main : main 함수 시작부터 40바이트를 부동 소수점 값 형식으로 출력
 x/10a main : 가장 가까운 심볼의 오프셋을 출력
 x/10s main : 문자열로 출력
 x/10i main : 어셈블리 형식으로 출력

29. 범위의 단위 (기본 word - 4바이트)
 x/10b main : byte - 1바이트 단위 - 10바이트 출력
 x/10h main : halfword - 2바이트 단위 - 20바이트 출력
 x/10w main : word - 4바이트 단위 - 40바이트 출력
 x/10g main : giant word - 8바이트 단위 - 80바이트 출력

30. 디스어셈블링 (disas)
 disas func : 어셈블리 코드를 좀 보편적으로 보기 위한 명령어
 disas 0x8048300 0x8048400 : 특정 주소 범위사이의 어셈블리 코드를 보기

31. 함수호출 (call)
 call func(arg1, arg2) : 특정함수 func를 arg1, arg2 파라메터를 포함하여 호출하고, 반환값은 출력

32. 점프 (jump)
 jump *0x08048321 : 해당 주소로 무조건 분기하여 인스트럭션을 계속 수행한다.
 jump 10  : 무조건 10행으로 분기하여 수행한다.
 jump func : func 함수로 무조건 분기하여 수행한다.

33. 시그널 전송 (signal)
 info signals : 보낼 수 있는 시그널의 종류를 확인할 수 있다.
 signal SIGKILL : 디버깅 대상의 프로세스에게 KILL 시그널을 보낼 수 있다.

34. 메모리의 특정 영역에 값을 설정 ( set )
 set {타입}[주소] = [값] : p 명령 대신에 set 을 통해서 메모리의 특정 주소에 저장하는 것이 더 일반적이다
 set {int}0x8048300 = 100 : 해당 주소에 100의 값을 입력한다.

35. gdb 환경설정 (set)
 info set : 변경 가능한 환경설정 정보를 출력한다.
 info functions : 함수들의 리스트를 출력
 info types  : 선언된 타입에 대한 리스트를 출력
 set prompt psyoblade: : 프롬프트를 psyoblade: 로 변경할 수 있다.
 set print array on : 배열을 출력할 때 한 행에 출력하는 것이 아니라 여러 행에 출력한다.

36. 기타 info 를 통해 알 수 있는 정보들
 address         catch           extensions      handle          objects         set             stack           tracepoints
 all-registers   common          files           heap            program         sharedlibrary   symbol          types
 architecture    copying         float           leaks           registers       signals         target          variables
 args            dcache          frame           line            remote-process  source          terminal        warranty
 breakpoints     display         functions       locals          scope           sources         threads         watchpoints
