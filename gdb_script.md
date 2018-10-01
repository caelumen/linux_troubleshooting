# [ GDB ] #

# 1. core dump 설정
<pre>
ulimit -a
ulimit -c unlimited
</pre>

# 2. 의도적 App. fault 유발

## python
<pre>
import sys
sys.setrecursionlimit(1<<30)
f = lambda f:f(f)
f(f)
</pre>

## C 언어 구문
<pre>

#include <stdio.h>
#include <stdlib.h>

void Abnormal()
{
    int n = 1024;
    char *p = (char *)malloc(sizeof(char) * 1);

    free(p);
    free(p);                /* double free */
    printf(p);
    void (*fp)();
    fp = p;
    fp();
}

void AbnormalContainer()
{
    Abnormal();
}

void Normal()
{
    printf("normal function.\n");
}

int main(int argc, char **argv)
{
    AbnormalContainer();
    Normal();
    return 0;
}

</pre>}

# compile a source that make a fault intentionally
<pre>
gcc -g -o test test_fault_01.c
./test
</pre>


# 누구의 Core 파일인가?
<pre>
file core.*
</pre>

# gdb 시작
gdb ./test core.*

# 주요 명령어

|   |   |
|---|---|
| where |  |
| bt
| b *main  |  |
| b 10  |  |
| run  |  |
| bt  |  |
| info register  |  |
| disas main  |  |


# apache 서비스 스타트 
<pre>
sudo yum install -y httpd
rpm -qa httpd
sudo service httpd start
</pre>

# attach debugger to  apache service
<pre>
[ec2-user@ip-172-31-18-1 ~]$ ps -ef | grep http
root      3750     1  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache    3751  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache    3752  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache    3753  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache    3754  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache    3755  3750  0 08:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache    3801  3750  0 08:12 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
</pre>

<pre>
sudo gdb -q -p 3750
generate-core-file
detach
q
</pre>

## source 출력 구간을 늘리려면,,,
<pre>
set listsize 100
</pre>

## gdb 실행중에 core. dump를 남긴다.
generate-core-file


***

#  Core Dump 파일 분석하기 #

코어  덤프  파일  정보  보기  <?xml:namespace prefix = o />
코어 덤프 파일은 프로젝트 디렉토리 하위의 build에 존재한다.
아래와 같이 코어 덤프 파일을 확인할 수 있다.

<pre>
SKA1DAP1:/SomeProject/build>ls
core.16195    core.8488     cursorserv    stdout
core.7000     core.9122     dispatcher    xdispatcher
core.7604     stderr

</pre>
코어 덤프 파일이 여러 개 있고, 서버도 여러 개 있기 때문에 디버깅 하려는 서버와 코어덤프 파일을 매칭 시켜야 한다.


## 코어 덤프 파일로부터 어떤 서버가 비정상종료 되었는지 확인하는 법 ##
<pre>
SKA1DAP1:/SomeProject/build>file core.7000
core.7000:     ELF-64 core file - IA64 원본 'cursorserv' - SIGSEGVÀÌ(이) 가 수신되었습니다.
</pre>
위의 코어 파일은 cursorserv 라는 서버로부터 생성된 코어 덤프이다.

##최신 코어 덤프 파일 확인하는 법 ##
<pre>
SKA1DAP1:/SomeProject/build>ls -tl | grep core  
-rw-------   1 jsh        users      102368064 8¿ù 22 21:43 core.9122
-rw-------   1 jsh        users      102499136 8¿ù 22 21:37 core.8488
-rw-------   1 jsh        users      102503232 8¿ù 22 21:32 core.7604
-rw-------   1 jsh        users      102503232 8¿ù 22 21:28 core.7000
-rw-------   1 jsh        users      102548400 8¿ù 22 15:43 core.16195

</pre>
최근에 생성된 순서로부터 보았을 때 core.9122가 최신 코어덤프 파일임을 알 수 있다.


# 코어  덤프  파일  정보  보기 #
## GDB로 코어 덤프 파일 분석하기 ##
`gdb [프로그램명] [코어파일명] `

<pre>
SKA1DAP1:/SomeProject/build >gdb cursorserv core.9122
HP gdb 5.8 for HP Itanium (32 or 64 bit) and target HP-UX 11.2x.
Copyright 1986 - 2001 Free Software Foundation, Inc.
. . .
</pre>

## backtrace 명령어로 콜스택 backtrace ##
<pre>
(gdb) bt
#0  inline std::allocator<char>::allocator(std::allocator<char> const&) ()
    at /opt/aCC/include_std/memory:252
#1  0x9fffffffbb8b7440:0 in inline std::basic_string<char,std::char_traits<char>,std::allocator<char> >::get_allocator() const ()
    at /opt/aCC/include_std/string:774
#2  0x9fffffffbb8b7420:0 in std::basic_string<char,std::char_traits<char>,std::allocator<char> >::basic_string (this=0x9fffffffffffdb58, __s=@0x0)
    at /opt/aCC/include_std/string:1035
#3  0x9fffffffbbbb2100:0 in nexcore::sql::Record::setValue (
    this=0x9fffffffffffdd30, key=@0x0, value=@0x9fffffffffffdca8)
    at nexcore/sql/Record.cpp:67
#4  0x9fffffffb99ec310:0 in int nexcore::sql::SqlManager::select<TestFun*,bool
    (this=0x600000000006d0c0, statementId=@0x9fffffffffffde00,
    params=0x9fffffffffffde30, c=0x60000000001340b0, mf=(bool ( class TestFun
    ::*)(class nexcore::sql::Record *...)) -147599808)
    at /home/jsh/nexbuild/nana/include/nexcore/sql/SqlManager.hpp:157
#5  0x9fffffffb99e9240:0 in TestFun::perform (this=0x60000000001340b0,
    request=0x6000000000141950, response=0x6000000000025840) at TestFun.cpp:103
#6  0x9fffffffbbc74510:2 in inline std::allocator<char>::allocator() ()
    at /opt/aCC/include_std/memory:250

</pre>
의심되는 스택 프레임으로 이동한다. 예를 들어 4번 프레임을 조사하고 싶으면, frame 4를 입력한다.
 



## Frame 4를 선택해서 스택 정보 보기 ##
<pre>
(gdb) f 4
#4  0x9fffffffb99ec310:0 in int nexcore::sql::SqlManager::select<TestFun*,bool
    (this=0x600000000006d0c0, statementId=@0x9fffffffffffde00,
    params=0x9fffffffffffde30, c=0x60000000001340b0, mf=(bool ( class TestFun
    ::*)(class nexcore::sql::Record *...)) -147599808)
    at /home/jsh/nexbuild/nana/include/nexcore/sql/SqlManager.hpp:157
157                                                             record.setValue( colNames[i], rset->getString(i+1) );

</pre>



해당 스택의 소스 보기
<pre>
(gdb) list
152                                             while(rset->next())
153                                             {
154                                                     Record record;
155                                                     for (int i=0; i<colCount; i++)
156                                                     {
157                                                             record.setValue( colNames[i], rset->getString(i+1) );
158                                                     }
159                                                    
160                                                     // call callback function

</pre>



해당 스택의 argument 보기
<pre>
(gdb) info arg
this = (class nexcore::sql::SqlManager * const) 0x600000000006d0c0
statementId = (
    class std::basic_string<char, std::char_traits<char>, std::allocator<char>>
     &) @0x9fffffffffffde00: {_C_data = 0x600000000013a4f0 "select",
  static __nullref = <optimized out>, static npos = <optimized out>}
params = (class nexcore::sql::Params *) 0x9fffffffffffde30
c = (class TestFun *) 0x60000000001340b0
mf = (bool ( class TestFun::*)(class nexcore::sql::Record *...)) (bool (
    class TestFun::*)(class nexcore::sql::Record *...)) -147599808

</pre>

해당 스택의 local value 보기

<pre>
(gdb) info local
i = 0
record = {record = {__t = {_C_buffer_list = 0x6000000000134d40,
      _C_free_list = 0x0, _C_next_avail = 0x60000000003cc650,
      _C_last = 0x60000000003ccc20, _C_header = 0x60000000003cc620,
      _C_node_count = 0, _C_insert_always = false,
      _C_key_compare = {<std::binary_function<std::string, std::string, bool>> = {<No data fields>}, <No data fields>}}}, __vfp = 0x9fffffffbb784110}
colCount = 2
resultCount = 0
selectCnt = 0
query = {
  _C_data = 0x6000000000033830 " SELECT A.NATION_CD AS nationCD, A.NATION_NM AS nationNM FROM PI_NATION A WHERE A.NATION_CD LIKE '%' || #nationCD# || '%' AND A.DEL_FLG='N' ", static __nullref = <optimized out>,
  static npos = <optimized out>}

</pre>
위와 같은 방식으로 코어 덤프 파일로부터 콜스택을 추적하여 프로그램이 비정상 종료된 원인을 찾아낸다. 자세한 명령어 및 검사방법은 GDB 기본 명령어 참조한다.


#실행중인 프로세스 디버깅 #
## 실행중인 프로세스 PID 보기 , ps –ef | grep [프로세스 명] ##

<pre>
SKA1PAP1:/>ps -ef | grep ae001serv
muxplt1 28238     1  0 12:00:43 ?         0:00 ae001serv -g 1 -i 200 -u SKA1PAP1 -U muxplt1  6153  6114  0 12:39:04 pts/10    0:00 grep ae001serv

</pre>

## 실행중인 프로세스에 attach , gdb [프로세스 명] [pid] ##
<pre>
SKA1PAP1:/ >gdb ae001serv 28238
HP gdb 5.8 for HP Itanium (32 or 64 bit) and target HP-UX 11.2x.
Copyright 1986 - 2001 Free Software Foundation, Inc.
. . .

</pre>

## 현재 프로세스의 스택 정보 ##
<pre>
(gdb) where
#0  0x9fffffffe2e31ad0:0 in _msgrcv_sys+0x30 () from /lib/hpux64/libc.so.1
#1  0x9fffffffe2e41270:0 in msgrcv ()
    at ../../../../../core/libs/libc/shared_em_64_perf/../core/syscalls/t_msgrcv.c:19
#2  0x9fffffffe43ccfe0:0 in _tmmbrecvm () at msg/tmmbrecvm.c:364
#3  0x9fffffffe4195a10:0 in _tmmsgrcv () at tmgetrply.c:652
</pre>
현재 프로세스의 스택 정보를 시작으로 정지점 이나 조건, watch 등 다양한 방법을 사용하여 디버깅을 진행한다.
GDB에 대한 자세한 명령어 및 검사방법은 GDB 기본 명령어 참조한다

