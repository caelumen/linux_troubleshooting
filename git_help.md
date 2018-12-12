[ Git Help ]
참조 : https://nolboo.kim/blog/2013/10/06/github-for-beginner/


~~~
git config --global user.name "이름"
git config --global user.email "깃허브 메일주소" // 매번 물어보는 귀찮음을 피하기 위해 설정.
~~~


~~~
mkdir ~/MyProject   // 로컬 디렉토리 만들고
cd ~/myproject      // 디렉토리로 들어가서
git init            // 깃 명령어를 사용할 수 있는 디렉토리로 만든다.
git status          // 현재 상태를 훑어보고
git add 화일명.확장자  // 깃 주목 리스트에 화일을 추가하고 or
git add .           // 이 명령은 현재 디렉토리의 모든 화일을 추가할 수 있다.
git commit -m “현재형으로 설명” // 커밋해서 스냅샷을 찍는다.

git remote add origin https://github.com/username/myproject.git // 로컬과 원격 저장소를 연결한다.
git remote -v // 연결상태를 확인한다.
git push origin master // 깃허브로 푸시한다.

~~~

# 예제 #

~~~
[root@clu_1 lkm]# git config --global user.name "Sangjae Lee"
[root@clu_1 lkm]# git config --global user.email "Git Email Address"
~~~

~~~
[root@clu_1 lkm]# git init
[root@clu_1 lkm]# git add hello.c
[root@clu_1 lkm]# git add hello_2.c
[root@clu_1 lkm]# git add Makefile
~~~

~~~
[root@clu_1 lkm]# git status
# On branch master
# Initial commit
# Changes to be committed:
#       new file:   Makefile
#       new file:   hello.c
#       new file:   hello_2.c
# Untracked files:
#       .hello.ko.cmd
#       .hello.mod.o.cmd
   [ 생   략 ]
~~~

~~~
[root@clu_1 lkm]# git commit -m "init Linux Kernel Module v.0.1"
[master (root-commit) 8f1deb9] init Linux Kernel Module v.0.1
 3 files changed, 54 insertions(+)
 create mode 100644 Makefile
 create mode 100644 hello.c
 create mode 100644 hello_2.c
~~~

~~~
[root@clu_1 lkm]# git remote remove origin
[root@clu_1 lkm]# git remote add origin https://github.com/windflex-sjlee/linux_troubleshooting.git
[root@clu_1 lkm]# git remote -v
origin  https://github.com/windflex-sjlee/linux_troubleshooting.git (fetch)
origin  https://github.com/windflex-sjlee/linux_troubleshooting.git (push)
[root@clu_1 lkm]# git push origin master
Username for 'https://github.com': windflex-sjlee
Password for 'https://windflex-sjlee@github.com':
~~~

