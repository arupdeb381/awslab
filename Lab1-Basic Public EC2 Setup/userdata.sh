#!/bin/bash
yum install -y httpd

cat <<EOF > /var/www/html/index.html
${INDEX_HTML}
EOF

systemctl start httpd
systemctl enable httpd

