#!/bin/bash
# mysql-full-backup.sh

# Change directories to the backup location.
cd /backups

host=$(getent hosts "$K8S_SERVICE_NAME" | cut -d' ' -f1 | head -n 1)
# Execute the compressed and encrypted full backup.
innobackupex --defaults-file=/xtrabackup/backup-my.cnf \
    --host=$host \
    --no-timestamp \
    --use-memory=1G \
    --stream=xbstream \
    --parallel=4 \
    --encrypt=AES256 \
    --encrypt-key-file=/xtrabackup-configs/.mykeyfile \
    --encrypt-threads=4 \
    --compress \
    --compress-threads=4 \
    --history=$(date +%d-%m-%Y) ./ > \
    mysqlbackup-$(date +%d-%m-%Y).qp.xbc.xbs

exit_status="$?"
echo "List of backups"
ls /backups
exit $exit_status