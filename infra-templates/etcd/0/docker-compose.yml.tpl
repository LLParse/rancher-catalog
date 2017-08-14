etcd:
    image: rancher/etcd:v3.0.17
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: etcd=true
        {{- end }}
        io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
        io.rancher.sidekicks: data
    environment:
        RANCHER_DEBUG: 'true'
        EMBEDDED_BACKUPS: '${EMBEDDED_BACKUPS}'
        BACKUP_PERIOD: '${BACKUP_PERIOD}'
        BACKUP_RETENTION: '${BACKUP_RETENTION}'
        ETCD_HEARTBEAT_INTERVAL: '${ETCD_HEARTBEAT_INTERVAL}'
        ETCD_ELECTION_TIMEOUT: '${ETCD_ELECTION_TIMEOUT}'
    volumes:
    - etcd:/pdata:z
    - /var/etcd/backups:/data-backup:z

data:
    image: busybox
    entrypoint: /bin/true
    net: none
    volumes:
    - /data
    labels:
        io.rancher.container.start_once: 'true'

