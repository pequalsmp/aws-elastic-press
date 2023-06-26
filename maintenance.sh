#!/bin/bash
ARCHIVE="${tar.content}"
apt-get -y update
apt-get -y install binutils libmariadb3 libmariadb-dev python3-pip python3-venv
curl -L -k "https://github.com/aws/efs-utils/tarball/master" | tar xz --directory /tmp
cd /tmp/aws-efs-utils-* || exit
bash build-deb.sh
cd - || exit
apt-get install -y /tmp/aws-efs-utils-*/build/amazon-efs-utils*deb
echo "${efs.id}:/ /mnt/ efs _netdev,noresvport,tls 0 0" >> /etc/fstab
mount -fa
mkdir -p "/mnt/maintenance" || exit
mkdir -p "/opt" || exit
echo -n "$ARCHIVE" | base64 --decode | tar xz --directory /opt/
cd /opt/maintenance || exit
echo "MOUNT_POINT=/mnt/maintenance" > .env
echo "RDS_HOST=${wp.db.host}" >> .env
echo "RDS_USER=${wp.db.user}" >> .env
echo "RDS_PASS=${wp.db.pass}" >> .env
echo "RDS_NAME=${wp.db.name}" >> .env
bash install.sh
cd - || exit
chmod -R 0700 /opt/maintenance
