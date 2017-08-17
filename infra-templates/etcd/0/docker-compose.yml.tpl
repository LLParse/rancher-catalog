version: '2'
services:
  etcd:
    # IMPORTANT!!!! DO NOT CHANGE VERSION ON UPGRADE
    image: llparse/etcd:holder
    entrypoint: /bin/sh
    command: -c "echo Refer to sidekick for logs; giddyup health -p 42"
    labels:
      {{- if eq .Values.CONSTRAINT_TYPE "required" }}
      io.rancher.scheduler.affinity:host_label: etcd=true
      {{- end }}
      io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.sidekicks: member
  member:
    image: llparse/etcd:v3.0.17
    environment:
      RANCHER_DEBUG: 'true'
      ETCD_HEARTBEAT_INTERVAL: '${ETCD_HEARTBEAT_INTERVAL}'
      ETCD_ELECTION_TIMEOUT: '${ETCD_ELECTION_TIMEOUT}'
    network_mode: container:etcd
    volumes:
    - etcd:/data:z
    {{- if ne .Values.BACKUP_RESTORE "" }}
    - {{ .Values.BACKUP_RESTORE }}:/backup:z
    {{- end }}
{{- if eq .Values.BACKUP_ENABLE "true" }}
  etcd-backup:
    image: llparse/etcd:v3.0.17
    entrypoint: /opt/rancher/etcdwrapper
    command:
    - rolling-backup
    - --creation=${BACKUP_CREATION}
    - --retention=${BACKUP_RETENTION}
    environment:
      RANCHER_DEBUG: 'true'
    volumes:
    - {{ .Values.BACKUP_NAME }}:/backup:z
volumes:
  {{ .Values.BACKUP_NAME }}:
    driver: rancher-nfs
    external: true
{{- end }}
