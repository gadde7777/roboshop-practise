#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"

if [ $USERID -ne 0 ]; then
echo -e "$R please run script with root user $N" | tee -a $LOGS_FILE
exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE()
{
if [ $1 -ne 0 ]; then
      echo "$2 ...Failure"| tee -a $LOGS_FILE
      exit 1
else
     echo "$2 ... Success"| tee -a $LOGS_FILE
fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo repo"

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "Install Mongo DB  Server"

systemctl enable mongod &>> $LOGS_FILE
VALIDATE $? "Enable MongoDB"

systemctl start mongod
VALIDATE $? "Start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing Remote Connections"

systemctl restart mongod
VALIDATE $? "Restart MongoDB"
