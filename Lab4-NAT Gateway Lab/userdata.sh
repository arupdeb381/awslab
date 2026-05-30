#!/bin/bash

cat <<EOF > /home/ec2-user/server01.pem
${PEM_FILE}
EOF

chmod 600 /home/ec2-user/server01.pem

chown ec2-user:ec2-user /home/ec2-user/server01.pem