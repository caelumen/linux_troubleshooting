

# Bash 에서 사용할 수 있는 Color Code:

( ANSI ESCAPE codes )

| Color  |  Code  |    Color   |  Code  |
| ------ | ------ | ---------- | ------ |
|Black        |0;30     |Dark Gray     |1;30  |
|Red          |0;31     |Light Red     |1;31  |
|Green        |0;32     |Light Green   |1;32  |
|Brown/Orange |0;33     |Yellow        |1;33  |
|Blue         |0;34     |Light Blue    |1;34  |
|Purple       |0;35     |Light Purple  |1;35  |
|Cyan         |0;36     |Light Cyan    |1;36  |
|Light Gray   |0;37     |White         |1;37  |


## Bash에서 실제 사용할 때
<pre>
echo -e "\033[0;31m  Color : RED \033[0m"
</pre>
or
<pre>
echo -e "\e[0;31m  Color : RED \e[0m"
</pre>

- MAC OS에서는 \e 대신  \x1B 사용 해야함

<pre>
RED='\033[0;31m'
NC='\033[0m' # No Color
printf "I ${RED}love${NC} Stack Overflow\n"
</pre>
