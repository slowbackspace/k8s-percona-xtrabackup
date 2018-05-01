#!/bin/bash
set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi
hostip=$(getent hosts percona-galera | cut -d' ' -f1 | head -n 1)
mkdir /xtrabackup

DATADIR="datadir=$(mysql -h $hostip -ubackup -p"${XTRABACKUP_PASSWORD}" -s -N -e "select @@datadir;" 2> /dev/null)"
INNODB_LOG_GROUP_HOME_DIR="innodb_log_group_home_dir=$(mysql -h $hostip -ubackup -p"${XTRABACKUP_PASSWORD}" -s -N -e "select @@innodb_log_group_home_dir;" 2> /dev/null)"
INNODB_DATA_DIR_HOME=$(mysql -h $hostip -ubackup -p"$XTRABACKUP_PASSWORD" -s -N -e "select @@innodb_data_home_dir;" 2> /dev/null)
if [ $INNODB_DATA_DIR_HOME = "NULL" ]; then
    INNODB_DATA_DIR_HOME=""
else
    INNODB_DATA_DIR_HOME="innodb_data_home_dir=${INNODB_DATA_DIR_HOME}"
fi


cat << EOF > /xtrabackup/backup-my.cnf
[client]
user=backup
password=$XTRABACKUP_PASSWORD
[mysqld]
${DATADIR}
${INNODB_LOG_GROUP_HOME_DIR}
${INNODB_DATA_DIR_HOME}
EOF


#chown backup /etc/mysql/backup-my.cnf
#chown backup /etc/mysql/.mykeyfile
#chmod 600 /xtrabackup/backup-my.cnf
#chmod 600 /xtrabackup-configs/.mykeyfile
printf "\nCreated Files: \n  /xtrabackup/backup-my.cnf \n  /xtrabackup/.mykeyfile \n"