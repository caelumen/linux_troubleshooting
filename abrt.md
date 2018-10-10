# ABRT (Automatic Bug Report Tool ) #

- abrt는 데몬의 형태로 구동해서, Application에서 발생하는 크래쉬를 감지 → 필요정보를 수집해서 저장
- Linux에서 Application이 간혹 Crash 나는 경우, 관련 정보가 얻기 힘들다...
  : 매번 에러가 발생하는 경우는 Debugging하면 되지만, Runtime으로 특정 상황에서만 어쩌다 죽는 경우 해당 시점의 정보를 얻기가 매우 어렵다. 
  : 이 경우, Crash 정보를 위해서 Coredump 파일을 남기는데 (나중에 gdb, backtrace로 분석/디버깅)
  : abrt는 이에 해당하는 정보를 쉽게 남기게 할 수 있다. 

## 설치 ##
 - Amazon Linux에서는 설치 되지 않음
<pre>
yum install abrt-cli
</pre>

<pre>
# service abrtd status
</pre>

<code>
[appadmin@localhost poc]$ `service abrtd status`
Redirecting to /bin/systemctl status  abrtd.service
● abrtd.service - ABRT Automated Bug Reporting Tool
   Loaded: loaded (/usr/lib/systemd/system/abrtd.service; enabled; vendor preset: enabled)
   Active: active (running) since 화 2018-10-09 23:43:20 PDT; 27min ago
 Main PID: 4792 (abrtd)
   CGroup: /system.slice/abrtd.service
           └─4792 /usr/sbin/abrtd -d -s

10월 09 23:43:20 localhost.localdomain systemd[1]: Started ABRT Automated Bug Reporting Tool.
10월 09 23:43:20 localhost.localdomain systemd[1]: Starting ABRT Automated Bug Reporting Tool...
10월 09 23:43:20 localhost.localdomain abrtd[4792]: Init complete, entering main loop
</code>





