## Installing the Chart

To deploy the chart with the release name `bitcoin-exporter`

````bash
helm template bitcoin-exporter . -f values.yaml 
helm install bitcoin-exporter . --namespace bitcoind
helm upgrade bitcoin-exporter . --namespace bitcoind -f values.yaml
helm uninstall bitcoin-exporter --namespace bitcoind
````