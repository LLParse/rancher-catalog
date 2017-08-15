version: '2'
services:
  etcd:
    # IMPORTANT!!!! DO NOT CHANGE VERSION ON UPGRADE
    image: llparse/etcd:holder
    command: sh -c "echo Refer to sidekick for logs; giddyup health -p 42"
    labels:
      {{- if eq .Values.CONSTRAINT_TYPE "required" }}
      io.rancher.scheduler.affinity:host_label: etcd=true
      {{- end }}
      io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.sidekicks: etcd-member
  etcd-member:
    image: llparse/etcd:v3.0.17
    environment:
      RANCHER_DEBUG: 'true'
      EMBEDDED_BACKUPS: '${EMBEDDED_BACKUPS}'
      BACKUP_PERIOD: '${BACKUP_PERIOD}'
      BACKUP_RETENTION: '${BACKUP_RETENTION}'
      ETCD_HEARTBEAT_INTERVAL: '${ETCD_HEARTBEAT_INTERVAL}'
      ETCD_ELECTION_TIMEOUT: '${ETCD_ELECTION_TIMEOUT}'
    network_mode: container:etcd
    volumes:
    - etcd:/pdata:z
    - /var/etcd/backups:/data-backup:z
