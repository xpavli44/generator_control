#!/bin/bash
users=$1

#log the attempt
echo -e "start measurment $(date) with $users users" >> /var/log/grafana_runs.log

#record measurement start point in grafna
curl -u guest:guest -X POST "http://10.199.16.164:8080/events/" -d '{"what": "demo", "tags": "demo test", "data": "'"$users"' users start"}'

#start the test
docker run --privileged --rm -v /root/sitespeed.io:/sitespeed.io sitespeedio/sitespeed.io sitespeed.io -f urls.txt -b firefox -n 3 --connection cable --graphiteHost 10.199.16.164  --seleniumServer http://127.0.0.1:4444/wd/hub --name "$users users"

#record mesurement stop in grafana
curl -u guest:guest -X POST "http://10.199.16.164:8080/events/" -d '{"what": "demo", "tags": "demo test", "data": "'"$users"' users stop"}'

#log the attempt
echo -e "stop measurment $(date) with $users users" >> /var/log/grafana_runs.log
