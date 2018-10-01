# TCPDUMP #

- TCPDUMP : Linux/Unix환경에서 네트워크 인터페이스를 거치는 패킷들을 출력/Dump하는 툴

## 기본 사용법 ##
<pre>
 tcpdump [options][expression][host]
</pre>

## Options ##
|    |    |
|----|----|
| -i device | 어느 인터페이스를 탭쳐할지 지정   |
| -w 파일명 | 캡쳐한 패킷을 저장할 파일이름 지정    |
| -c number | 캡쳐할 패킷수를 지정    |
| -s length | 패킷으로부터 캐쳐한 양을 지정 (default : 68 byte)    |

## 기타 : Packet Flag ##
|    |    |
|----|----|
| S | SYN. 연결 요청 |
| F | FIN. 연결 종료 요청 |
| R | RST. 즉시 연결 종료 |
| P | PSH. 프로세스로 데이터 전송|
| U | URG. 긴급한데이터전송. 우선순위 할당함   |
| . | Flag 설정하지 않음 |


## TCPDUMP 사용의 예 ##
- tcpdump -i eth0 => 인터페이스 eth0 을 보여줌
-  tcpdump -w tcpdump.log => 결과를 파일로 저장, txt 가 아닌 bin 형식으로 저장됨

-  tcpdump -r tcpdump.log => 저장한 파일을 읽음

-  tcpdump -i eth0 -c 10 => 카운터 10개만 보여줌

-  tcpdump -i eth0 tcp port 80 => tcp 80 포트로 통신하는 패킷 보여줌

-  tcpdump -i eth0 src 192.168.0.1 => source ip 가 192.168.0.1인 패킷 보여줌

-  tcpdump -i eth0 dst 192.168.0.1 => destination ip 가 192.168.0.1인 패킷 보여줌
* and 옵션으로 여러가지 조건의 조합 가능

-  tcpdump -i eth0 src 192.168.0.1 and tcp port 80 => source ip 가 192.168.0.1이면서 tcp port 80 인 패킷 보여줌

-  tcpdump -i eth0 dst 192.168.0.1 => dest ip 가 192.168.0.1인 패킷 보여줌

-  tcpdump host 192.168.0.1 => host 를 지정하면, 이 ip 로 들어오거가 나가는 양방향 패킷 모두 보여줌

-  tcpdump src 192.168.0.1 => host 중에서 src 가 192.168.0.1인것 만 지정

-  tcpdump dst 192.168.0.1 => host 중에서 dst 가 192.168.0.1인것 만 지정

-  tcpdump net 192.168.0.1/24 => CIDR 포맷으로 지정할 수 있다.

-  tcpdump tcp => TCP 인것만

-  tcpdump udp => UDP 인것만

-  tcpdump port 3389 => 포트 양뱡항으로 3389인 것.

-  tcpdump src port 3389 => src 포트가 3389인 것.

-  tcpdump dst port 3389 => dst 포트가 3389인 것.
* combine : and ( && ) , or ( || ) , not ( ! ) 으로 여러가지를 조합해서 사용 가능

-  tcpdump udp and src port 53 => UDP 이고 src 포트가 53 인 것

-  tcpdump src x.x.x.x and not dst port 22 => src ip 가 x.x.x.x 이고 dst 포트가 22 가 아닌 것
* grouping : ( )

-  tcpdump ‘src x.x.x.x and ( dst port 3389 or 22 )’ => src ip 가 x.x.x.x 이고 ( dst 포트가 3389 또는 22 ) 인 것 ==> 여기서는 ‘ ‘ 가 반드시 있어야 한다.





















