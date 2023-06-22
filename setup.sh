#!/bin/bash
apt-get -y update
apt-get -y install git binutils
git clone https://github.com/aws/efs-utils /tmp/
cd /tmp/efs-utils || exit
./build-deb.sh
apt-get install -y ./build/amazon-efs-utils*deb
mkdir -p "/var/www/html"
echo "${efs.id}:/ /var/www/html efs _netdev,noresvport,tls,iam 0 0" | tee /etc/fstab
mount -fa
apt-get -y install dockerio
systemctl enable --now docker
docker run \
	-e WORDPRESS_DB_HOST="${wp.db.host}" \
	-e WORDPRESS_DB_USER="${wp.db.user}" \
	-e WORDPRESS_DB_PASSWORD="${wp.db.pass}" \
	-e WORDPRESS_DB_NAME="${wp.db.name}" \
	-e WORDPRESS_DB_TABLE_PREFIX="${wp.db.prefix}" \
	-d \
	-v /var/www/html:/var/www/html \
  -p 80:80 \
	wordpress:"${container.tag}"@"${container.digest}"
