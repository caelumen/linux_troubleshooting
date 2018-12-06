
# Risk in Shell Script #

- 모든 계정 이름 가져오기
<pre>
cat /etc/passwd | awk '{print $3}'
</pre>
or
<pre>
cat /etc/passwd | cut -d: -f1
</pre>

- 모든 계정별 어떤 명령어 수행 (ex. 계정명 출력)

<pre>
for id in `cat /etc/passwd | awk '{FS=":"}{print$1}'`; do echo $id; done;
</pre>

or
<pre>
for id in $(cat /etc/passwd | awk '{FS=":"}{print$1}'); do echo $id; done;
</pre>


## Risk Point (Enter 혹은 \n, \r 등 삽입) ##
<pre>
for id in $(cat /etc/passwd | awk '{FS=":"}{print$1}'); do echo 
AA$id; done;
</pre>


## 좀 더 테스트를 위해서 ##
<pre>
for id in $(cat /etc/passwd | awk '{FS=":"}{print$1}'); do echo AA$id; done;
</pre>

## 임의로 AA를 앞부분에 덧붙인 명령어를 만든다.##
<pre>
cat > AAhalt
</pre>

<pre>
RED='\033[0;31m'
NC='\033[0m' # No Color
echo -e "${RED}## HALT Command EXECUTED !! ${NC}"
</pre>

## 권한변경하고, sbin 디렉토리로 이동 ##
<pre>
chmod u+x ./AAhalt
mv ./AAhalt /sbin/
</pre>
