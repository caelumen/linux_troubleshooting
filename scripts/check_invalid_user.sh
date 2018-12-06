grep 'invalid user' /var/log/auth.log | awk '{F=" "}{print$9}' | sort - | uniq -c | sort -nr
