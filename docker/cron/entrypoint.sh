# export HOST=0.0.0.0
# /usr/sbin/crond -f -l 2
# crontab-ui

/usr/sbin/crond

while true; do
    echo `date` Container is running
    sleep 10
done

echo `date` Container crashed