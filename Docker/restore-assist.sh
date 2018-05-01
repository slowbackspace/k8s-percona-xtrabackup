#!/bin/bash
set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi
mkdir -p /backups/restore/tmp /backups/restore/full
cd /backups
ls /backups
cp *mysqlbackup-${RESTORE_DATE}.qp.xbc.xbs  /backups/restore/tmp

cat << EOF > /backups/my.cnf
[client]
user=backup
password=$XTRABACKUP_PASSWORD
[mysqld]
datadir=/var/lib/mysql
EOF

# Extract the encrypted files from the archive.
cat /backups/restore/tmp/mysqlbackup-${RESTORE_DATE}.qp.xbc.xbs | xbstream -x -C /backups/restore/full/
# Decrypt the files
find /backups/restore/full -name "*.xbcrypt" -type f -exec bash -c 'f={} && nf=${f%.xbcrypt} && \
    cat {} | xbcrypt -da AES256 -f /xtrabackup-configs/.mykeyfile -o ${nf} && rm {}' \;
# Decompress the backup:
innobackupex --use-memory=1G --parallel=4 --decompress /backups/restore/full
# If there are .qp files remaining after the decompression phase, remove them
find /backups/restore/full/ -name "*.qp" -exec rm {} \;

innobackupex --use-memory=1G --apply-log /backups/restore/full