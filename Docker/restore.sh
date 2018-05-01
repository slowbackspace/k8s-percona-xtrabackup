#!/bin/bash

./restore-assist.sh

# TODO stop cluster
rm -rf /backups/mysql_backup/mysql
mv /var/lib/mysql /backups/mysql_backup

# restore
# cp /xtrabackup/backup-my.cnf /xtrabackup/my.cnf

innobackupex --defaults-file="/backups/my.cnf" --copy-back /backups/restore/full

# TODO start cluster