#!/bin/bash
apt-get -y update
apt-get -y install binutils docker.io
curl -L -k "https://github.com/aws/efs-utils/tarball/master" | tar xz --directory /tmp
cd /tmp/aws-efs-utils-* || exit
bash build-deb.sh
cd - || exit
apt-get install -y /tmp/aws-efs-utils-*/build/amazon-efs-utils*deb
echo "${efs.id}:/ /mnt efs _netdev,noresvport,tls 0 0" >> /etc/fstab
mount -fa
mkdir -p "/mnt/wordpress" || exit
systemctl enable --now docker
docker run \
	--env WORDPRESS_DB_HOST="${wp.db.host}" \
	--env WORDPRESS_DB_USER="${wp.db.user}" \
	--env WORDPRESS_DB_PASSWORD="${wp.db.pass}" \
	--env WORDPRESS_DB_NAME="${wp.db.name}" \
	--env WORDPRESS_DB_TABLE_PREFIX="${wp.db.prefix}" \
	--detach \
	--publish 80:80 \
	--restart unless-stopped \
	--volume /mnt/wordpress:/var/www/html \
	"wordpress@${container.digest}"
