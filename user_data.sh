#!/bin/bash

# Install AWS CLI if not present
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

# Fetch DB password from Secrets Manager
DB_PASSWORD=$(aws secretsmanager get-secret-value \
    --region ${AWS_REGION} \
    --secret-id ${DB_SECRET_NAME} \
    --query SecretString \
    --output text | jq -r .password)

# Export env variables
cat <<EOL > /opt/webapp/.env
DB_HOST=${DB_HOST}
DB_NAME=csye6225
DB_USER=csye6225
DB_PASSWORD=${DB_PASSWORD}
S3_BUCKET_NAME=${S3_BUCKET_NAME}
AWS_REGION=${AWS_REGION}
EOL

chown csye6225:csye6225 /opt/webapp/.env
chmod 600 /opt/webapp/.env

systemctl restart webapp.service