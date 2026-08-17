#!/bin/bash
BACKUP_DIR="/opt/etcd-backups"
DATE=$(date +%Y-%m-%d_%H%M%S)

# Set API version to 3
export ETCDCTL_API=3

# Take snapshot
/usr/local/bin/etcd/bin/etcdctl snapshot save "${BACKUP_DIR}/etcd-snapshot-${DATE}.db"

# Delete backups older than 7 days to save space
find "${BACKUP_DIR}" -name "etcd-snapshot-*.db" -mtime +7 -delete
