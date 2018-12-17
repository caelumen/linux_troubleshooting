# Kernel Parameter Tunning #



ㅇ 커널 파리미터 설정
 sysctl -a
 sysctl -w net.ipv4.tcp_keepalive_time=3600
 sysctl -p

※ 공백이 없음에 유의한다.
※ 시스템 부팅시 설정되도록 하려면, /etc/sysctl.conf 파일에 설정값 기록
※ sysctl -p 명령은 리부팅없이 설정을 적용한다.


ㅇ TCP 커널 파라미터
### timeout_timewait 매개변수 ###
- session close와 연결해제하여 자원을 해재하는 사이의 시간
- 기본값 240초(4분), 최소 권장 30초
- 해당 기간내에, Client-서버간 연결을 연결을 여는것이, New Connection을 만드는 것보다 비용이 저렴

echo X > /proc/sys/net/ipv4/tcp_fin_timeout


### 연결 백로그### 
- 수신 연결 요청이 버스트 하면, 백로그 값을 늘림
echo X > /proc/sys/net/core/netdev_max_backlog
echo X > /proc/sys/net/core/somaxconn

### tcp_keepalive_time ### 
- Tcp/IP가 대기 연결이 계속 원래 상태를 유지하는지 확인을 시도하는 빈도를 제어
- 7,200초(2시간) 동안 대기 연결이 비활성 상태일 경우 Linux에서 Active 상태 지속 메세지를 전송
- 종종 1,800초를 선택하여 half-closed conn.을 30분마다 감지

echo X > /proc/sys/net/ipv4/tcp_keepalive_time

###  tcp_keepalive_intvl 값 ### 
- tcp_keepalive_intvl : Active State 지속응답이 수신되지 않을 경우, 
- TCP/IP에서 Active 상태 지속 전송을 반복하는 빈도를 결정
- 응답시간이 길 것으로 예상되는 경우, 이 값을 늘려 오버헤드를 줄인다. 
- 기본값 : 75초 동안 Active State 지속응답을 대기
- 종종 15초를 선택하여 손실된 상대를 더 빨리 감지

echo X > /proc/sys/net/ipv4/tcp_keepalive_intvl

###  tcp_keepalive_probes 값 ### 
- TCP/IP가  Active State가 수신되지 않은 연경에 재전송하는 횟수 

echo X > /proc/sys/net/ipv4/tcp_keepalive_probes


ㅇ 참조 : https://meetup.toast.com/posts/53
http://nblog.syszone.co.kr/archives/2832
