#!/bin/bash
ARCHIVE="${tar.content}"
apt-get -y update
apt-get -y install binutils libmariadb3 libmariadb-dev python3-pip python3-venv
curl -L -k "https://github.com/aws/efs-utils/tarball/master" | tar xz --directory /tmp
cd /tmp/aws-efs-utils-* || exit
bash build-deb.sh
apt-get install -y build/amazon-efs-utils*deb
cd - || exit
mkdir -p "/mnt" || exit
echo "${efs.id}:/ /mnt efs _netdev,noresvport,tls 0 0" | tee -a /etc/fstab
mount -fa
mkdir -p "/opt" || exit
echo -n "$ARCHIVE" | base64 --decode | tar xz --directory /opt/
cd /opt/maintenance || exit
echo "MOUNT_POINT=/mnt" | tee env
echo "RDS_HOST=${wp.db.host}" | tee -a env
echo "RDS_USER=${wp.db.user}" | tee -a env
echo "RDS_PASS=${wp.db.pass}" | tee -a env
echo "RDS_NAME=${wp.db.name}" | tee -a env
bash install.sh
cd - || exit
chmod -R 0700 /opt/maintenance
