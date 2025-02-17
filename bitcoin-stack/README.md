# Package and deploy the Umbrella Chart

````bash
helm dependency update
helm package .
helm install bitcoin-stack ./bitcoin-stack-0.1.0.tgz
helm upgrade --install bitcoin-stack ./bitcoin-stack-0.1.0.tgz
````

# Expose the services using ingress configurations with Traefik Ingress controller

````bash
kubectl apply -f grafana-ingress.yaml
kubectl apply -f prometheus-ingress.yaml
kubectl apply -f btc-exporter-ingress.yaml
````

````bash
# /etc/hosts
127.0.0.1 grafana.local
127.0.0.1 prometheus.local
127.0.0.1 btc-exporter.local
````

Access the Services

- Grafana: http://grafana.local
- Prometheus: http://prometheus.local
- BTC Exporter: http://btc-exporter.local
