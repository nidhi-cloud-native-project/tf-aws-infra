#!/bin/bash
echo "DB_HOST=${DB_HOST}" >> /opt/webapp/.env
echo "DB_NAME=csye6225" >> /opt/webapp/.env
echo "DB_USER=csye6225" >> /opt/webapp/.env
echo "DB_PASSWORD=${DB_PASSWORD}" >> /opt/webapp/.env
echo "S3_BUCKET_NAME=${S3_BUCKET_NAME}" >> /opt/webapp/.env
echo "AWS_REGION=${AWS_REGION}" >> /opt/webapp/.env

chown csye6225:csye6225 /opt/webapp/.env
chmod 600 /opt/webapp/.env

systemctl restart webapp.service