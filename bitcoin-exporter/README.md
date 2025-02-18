# Bitcoin Metrics Exporter

Prometheus exporter for Bitcoin node metrics.

## Metrics Exposed
- `bitcoin_block_height`: Current blockchain height
- `bitcoin_peer_count`: Number of connected peers
- [Add other metrics](https://github.com/Aminechakr/bitcoin-node-observer/issues)

## Building

```bash
#Build the image
docker build -t bitcoin-exporter .
``` 

```bash
#Run the docker locally
docker run -d \
  --name bitcoin-exporter \
  -e RPC_URL="http://host.docker.internal:38332" \
  -e RPC_USER="foo" \
  -e RPC_PASSWORD="xxxxxxxxxx" \
  -e METRICS_PORT="9100" \
  -p 9100:9100 \
  bitcoin-exporter:latest
```

````bash
#Required env vars
export RPC_URL="http://127.0.0.1:38332"
export RPC_USER="foo" 
export RPC_PASSWORD="" METRICS_PORT=9100
````

````bash
go build -o bitcoin-exporter cmd/main.go
./bitcoin-exporter
````

````bash
#check your metrics
curl http://localhost:9100/metrics
````

## Helm Deployment
See the [chart README](./chart/README.md) for deployment instructions.
