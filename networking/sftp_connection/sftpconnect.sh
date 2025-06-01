#!/bin/bash

USER="your_username"
HOST="sftp.example.com"
PASSWORD="your_password"

sshpass -p "$PASSWORD" sftp -oStrictHostKeyChecking=no $USER@$HOST
