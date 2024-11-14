#!/bin/bash
url='http://localhost:8081/api/greetings'
attempts=0
timeout=10
online=false

cont="y"
while [ "$cont" = "y" ];
do
    code=`curl -sL --connect-timeout 20 --max-time 30 -w "%{http_code}\\n" "$url" -o /dev/null`

    if [[ "$attempts" -gt "20" ]]
        then
            break
        fi

    if [ "$code" = "200" ]; then
        break
    else
        sleep $timeout
    fi

    attempts=$(( $attempts + 1 ))
done
