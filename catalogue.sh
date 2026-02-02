#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)
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
      echo "$2 ...FailureS"| tee -a $LOGS_FILE
      exit 1
else
     echo "$2 ... Success"| tee -a $LOGS_FILE
fi
}

dnf module disable nodejs -y &>> $LOGS_FILE
VALIDATE $? "Disable Nodejs"

dnf module enable nodejs:20 -y &>> $LOGS_FILE
VALIDATE $? "Enable NodeJs 20"

dnf install nodejs -y &>> $LOGS_FILE
VALIDATE $? "Install Nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "Creating System User"


mkdir /app 
VALIDATE $? "Creating Directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "Downloading Code"
##cd /app 
##unzip /tmp/catalogue.zip

##cd /app 
##npm install 