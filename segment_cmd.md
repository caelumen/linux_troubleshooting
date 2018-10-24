# 구분자에 따른 Tokenize #

<pre>
cat /etc/group | cut -d: -f1
</pre>

<pre>
cat /etc/group | awk -F: '{print$1}'
</pre>

<pre>
cat /etc/group | sed 's/:.*//'
</pre>


<pre>
for id in `cat /etc/group | awk -F: '{print$1}'`; do echo $id; done;
</pre>
