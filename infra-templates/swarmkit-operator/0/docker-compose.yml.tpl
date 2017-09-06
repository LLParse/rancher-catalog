version: '2'
services:
  linux-proxy:
    image: llparse/swarmkit-operator:dev
    command: proxy
    environment:
      PROXY_BIND: "${PROXY_BIND}"
    labels:
      io.rancher.container.agent.role: environment
      io.rancher.container.create_agent: 'true'
      io.rancher.container.pull_image: always
      io.rancher.scheduler.affinity:host_label: io.rancher.host.os=linux
      io.rancher.scheduler.global: 'true'
    network_mode: host
    privileged: true
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
  windows-proxy:
    image: llparse/swarmkit-operator:dev_windows
    command: proxy
    environment:
      PROXY_BIND: "${PROXY_BIND}"
    labels:
      io.rancher.container.agent.role: environment
      io.rancher.container.create_agent: 'true'
      io.rancher.container.pull_image: always
      io.rancher.scheduler.affinity:host_label: io.rancher.host.os=windows
      io.rancher.scheduler.global: 'true'
{{- if eq .Values.TARGET_OS "linux" }}
  linux-operator:
    image: llparse/swarmkit-operator:dev
    command: orchestrate
    environment:
      MANAGER_SCALE: ${MANAGER_SCALE}
      RECONCILE_PERIOD: ${RECONCILE_PERIOD}
    labels:
      io.rancher.container.agent.role: environment
      io.rancher.container.create_agent: 'true'
      io.rancher.container.pull_image: always
      io.rancher.scheduler.affinity:host_label: io.rancher.host.os=linux
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
{{- else }}
  windows-operator:
    image: llparse/swarmkit-operator:dev_windows
    command: orchestrate
    environment:
      MANAGER_SCALE: ${MANAGER_SCALE}
      RECONCILE_PERIOD: ${RECONCILE_PERIOD}
    labels:
      io.rancher.container.agent.role: environment
      io.rancher.container.create_agent: 'true'
      io.rancher.container.pull_image: always
      io.rancher.scheduler.affinity:host_label: io.rancher.host.os=windows
{{- end }}