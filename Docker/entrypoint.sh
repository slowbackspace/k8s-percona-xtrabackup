#!/bin/bash
set -e # Any subsequent(*) commands which fail will cause the shell script to exit immediately

if [[ "$BACKUP_TYPE" == "full" ]]; then
    ./backup-assist.sh
    ./full-backup.sh
elif [[ "$BACKUP_TYPE" == "incremental" ]]; then
    ./backup-assist.sh
    ./inc-backup.sh
elif [[ "$BACKUP_TYPE" == "restore" ]]; then
    ./restore.sh
else
    echo "Uknown backup type."
    exit 1
fi