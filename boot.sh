#!/bin/bash
set -m
echo "[database]
MYSQL_HOST=$MYSQL_HOST
MYSQL_PORT=$MYSQL_PORT
MYSQL_DB=$MYSQL_DATABASE
MYSQL_USER=$MYSQL_USER
MYSQL_PASSWORD=$MYSQL_PASSWORD" > backend.conf
wait-for-it -h $MYSQL_HOST -p 3306 -t 20
if [ $? -eq 0 ]
then
    gunicorn -b "0.0.0.0:$BACKEND_PORT" "wsgi:app" &
    wait-for-it -h 'localhost' -p "$BACKEND_PORT"
    if [ $? -eq 0 ]
    then
        curl -X POST "localhost:$BACKEND_PORT/add"\
            -H "Content-Type: application/json"\
            -d "{\"name\":\"$STUDENT_NAME\",\"bcit_id\":\"$STUDENT_ID\"}"
    else
        echo "Could not connect to application"
    fi
    fg %1
else
    echo "Could not connect to DB"
    exit 1
fi