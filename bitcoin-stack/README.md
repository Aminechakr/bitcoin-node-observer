# Bitcoin Stack Helm Chart

Umbrella chart for deploying the complete Bitcoin node monitoring solution.

## Components
- Bitcoin Signet Node
- Bitcoin Metrics Exporter
- Prometheus
- Grafana
- Pre-configured dashboards

## Installation

````bash
# Update dependencies
helm dependency update
# Package the umbrella chart
helm package .
# Install the stack
helm install bitcoin-stack ./bitcoin-stack-0.1.0.tgz
#or without packaging
helm install bitcoin-stack .
#upgrade your stack
helm upgrade --install bitcoin-stack ./bitcoin-stack-0.1.0.tgz
````

````bash
# /etc/hosts
127.0.0.1 grafana.local
127.0.0.1 prometheus.local
127.0.0.1 btc-exporter.local
````

## Access Services
- Grafana: http://grafana.local
- Prometheus: http://prometheus.local
- Bitcoin Exporter: http://btc-exporter.local