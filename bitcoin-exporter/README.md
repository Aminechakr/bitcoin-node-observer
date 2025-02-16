#

go get github.com/prometheus/client_golang/prometheus
go get github.com/prometheus/client_golang/prometheus/promhttp
go build -o bitcoin-exporter cmd/main.go
./bitcoin-exporter
curl http://localhost:9100/metrics