# Linux log files

Linux는 시스템이 어떠한 중요한 Event가 발생했는지를 관리자가 인지할 수 있도록, Log file을 남겨놓는다.
이러한 로그파일은, 그 종류에 따라 Kernel, service, application, security 등으로 나뉘며, 
각각 산재되어 있는 로그를 한곳으로 모아 저장해 둔다. 이 수집된 위치가 `/var/log/` Directory이다.

관리자는 내부 로그에 대한 관리의 책임이 있으므로, Log file들을 모니터링하여 서버의 성능/보안/각종 에러메세지를 관리/분석 함으로써, 발생가능한 이슈를 사전에 예장해야 한다. 

# Log Types
Log의 종류는 아래와 같이 분류 할 수 있다. 
- Application Logs
- Event Logs
- Service Logs
- System Logs

# Log Files
이번에는 아래와 같은 주요 파일에 대하여 설명한다. 
- /var/log/messages
- /var/log/auth.log
- /var/log/secure
- /var/log/boot.log
- /var/log/kern.log
- /var/log/faillog
- /var/log/yum.log
- /var/log/httpd/
- /var/log/mysql.log or /var/log/mysqld.log
- /var/log/dmesg


# Log files 상세

## /var/log/messages
- /var/log/messages에는 일반적인 시스템 Activity log를 포함한다. 
- critical message보다는 주로 information에 관련된 로그를 담고 있다. 
- Debian기반 배포판에서는 /var/log/syslog 가 동일한 역할을 하고 있다. 

## 활용 ##
- non-kernel boot error , application 관련 서비스 에러, 시스템 시작시 로깅 메세지 등을 확인할 수 있다. 
- Linux System에 문제가 발생했을 경우, 가장 처음 확인해 봐야할 로그이다. 
- 예로, 사운드카드 문제가 발생했을 경우, 
  시스템 Startup Process에서 무엇인가 잘못된 것이 없는지 확인해야 하는데, 
  이 때  messages 로그 파일은 가장 처음 확인 해봐야 한다.  
   
   example)
<pre>
**$ sudo tail -n 20 /var/log/messages**
    Oct  1 08:07:32 ip-172-31-18-1 dhclient[2976]: XMT: Solicit on eth0, interval 120590ms.
    Oct  1 08:09:32 ip-172-31-18-1 dhclient[2976]: XMT: Solicit on eth0, interval 116670ms.
    Oct  1 08:10:01 ip-172-31-18-1 systemd: Created slice User Slice of root.
    Oct  1 08:10:01 ip-172-31-18-1 systemd: Starting User Slice of root.
    Oct  1 08:10:01 ip-172-31-18-1 systemd: Started Session 676 of user root.
    Oct  1 08:10:01 ip-172-31-18-1 systemd: Starting Session 676 of user root.
    Oct  1 08:10:01 ip-172-31-18-1 systemd: Removed slice User Slice of root.
    Oct  1 08:10:01 ip-172-31-18-1 systemd: Stopping User Slice of root.
</pre>

## /var/log/auth.log  or /var/log/secure ##
- Debian 계열 (Ubuntu)에서 남겨지는 로그 파일이며, 인증 (authentication 관련 이벤트)가 기록된다. 
- 로그인/인증 메커니즘 관련 사항을 확인하고자 할 때, auth.log 파일을 확인한다. 
- RedHat or CentOS 기반 배포판은 `/var/log/secure` 를 확인한다.
- sudo 로그인, SSH 로그인 및 관련 에러를 포함하고 있다. 

### 활용 ###
- 누가 언제 어떤 계정으로 접속 시도/성공 했는지
- Brute-force 공격이 시도 되었는지 or 인증 메커니즘 관련 취약점은 없는지.. Hacking 시도가 있었는지 등
- 공격 발생 시점에 누가 접속 했었는지.. 여부 등
- 로그인 성공 이력 및 사용자 정보 확인 

StackEdit stores your files in your browser, which means all your files are automatically saved locally and are accessible **offline!**

## /var/log/boot.log ##
- system initialization script, /etc/init.d/bootmisc.sh 등에서 발생하는 부팅 관련 로그 파일을 저장한다.
- 부팅 과정에서 발생한 메세지가 저장된다. 
- 비정상적 shutdown, reboot, booting failure 등이 기록되며, 예기치 못한 시스템 downtime을 확인 할수 있다.  


## /var/log/dmesg ##
- kernel ring buffer message를 포함하고 있다. 
- 따라서, HW device, driver 관련된 정보를 포함하고 있으며, 
- 주로, 부팅과정에서 physical device와 연관된 상태, 에러 등의 메세지를 확인한다. 
- 어떤 HW가 비정상 동작하는지, 센싱되지 않는지 등 trouble이 발생했을 때 사용한다. 


## /var/log/kern.log ##
- 커널에 의하여 로깅되는 정보를 담고 있다. 
- 주로 custom-built kernel을 트러블슈팅하거나 디버깅 할 때 사용한다. 

## /var/log/cron##
- cron job에 대한 로그 파일다. 
- cron job 실행 될 때, 성공/실패 등에 대한 에러/information 을 기록하고 있다. 
- Cron schedul에 문제가 발생하면, 해당 파일을 먼저 확인 한다. 
- 
## /var/log/yum.log ##
- yum 명령어를 사용하여 새로운 패키지를 인스톨할 때 생성되는 로그이다. 
- SW패키지와 시스템 컴포넌트 설치를 추적/확인 할 수 있으며, 패키지들이 정확하게 설치되었는지 로깅된다.
- SW 인스톨 관련하 troubleshooting에 활용될 수 있다. 
- 만약, 패키지 설치 후, 서버가 비정상 동작을 할 경우, 가장 최근에 설치된 패키지 확인/정상동작 여부 등을 확인할 수 있다. 
- 
## /var/log/maillog or /var/log/mail.log ##
- 메일서버 관련한 로그가 저장된다. 
- postfix, smtpd, MailScanner, SpamAssassain 등 이메일 관련한 서비스의 로그를 저장하며, 
- 특정 기간동안 이메일의 송수신 및 차단을 추적할 수 있다. 


## /var/log/httpd/ ##
- Apache Web Server 관련된 로그를 기록하고 있다.  access_log와 error_log 2종의 파일이 기록된다. 
- error_log는 메모리 이슈 같은 httpd error를 포함하여, httpd 요청 시 발생하는 에러들이 기록된다. 
- Apache webserver가 오동작하고, 원인진단이 필요하면 error_log를 확인하는 것이 좋다. 
- error 외에 request에 관련된 일반 로그는 access_log에 기록된다. 
- Apaceh webserver에 의하여 서비스 되는 파일 추적, 접속 IP, USer ID, 요청/연결 정보, Response의 정상/실패 등의 정보 확인이 가능하다. 

## /var/log/mysqld.log  or /var/log/mysql.log ##
- MySQL에서 제공하는 로그로, mysqld에 관련되 성공/실패에 대한 모든 로그가 기록된다. 
- RedHat, CentOS, Fedora는 `/var/log/mysqld.log` 에 저장되고, Debian, Ubuntu `/var/log/mysql.log`에 저장된다. 
- mysql의 시작/중단/동작 등을 확인 할 수 있으며, Client Connection 정보 또한 확인이 가능하다. 
 

개별 모니터링 하는 것은 매우 어려운 작업중에 하나이다. 따라서 각종 로그들을 중앙화/단순화 하는 프로세스가 필요하다. 일부 조직에서는 Nagios 등을 이용하여 Log Management System을 운영하기도 하며, Nagios외에도 오픈소스 기반으로한 다양한 로그 모니터링 시스템이 존재한다. 
따라서, 시스템 이상현상을 분석하기 위해서는 중앙화/단순화 된 로그 관리 시스템의 도입이 필요하며, 이를 통하여 Risk를 사전에 예방 할 수 있을 것이다. 




마크업 문서 작성 :  https://stackedit.io/app#
