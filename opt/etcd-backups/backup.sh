#!/bin/bash
BACKUP_DIR="/opt/etcd-backups"
DATE=$(date +%Y-%m-%d_%H%M%S)

# Enforce API version 3
export ETCDCTL_API=3

# Take secure snapshot using local TLS assets
/usr/local/bin/etcd/bin/etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save "${BACKUP_DIR}/etcd-snapshot-${DATE}.db"

# Delete backups older than 7 days to save space
find "${BACKUP_DIR}" -name "etcd-snapshot-*.db" -mtime +7 -delete

#previous backup got hung due to TLS auth handshake requirments enformed on the cluster. It was dropping unencrypted anonymous snapshot requests. 
To fix this, passed cluster's certificate authority (ca.crt), client certificate (server.crt), and private key (server.key) directly inside the backup script so etcdctl 
can pass the secure handshake.
