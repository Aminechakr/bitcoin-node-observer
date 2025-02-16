package main

import (
	"log"
	"net/http"
	"time"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/aminechakr/bitcoin-exporter/internal"
)

const (
	rpcURL      = "http://127.0.0.1:8332"
	rpcUser     = "your_rpc_user"
	rpcPassword = "your_rpc_password"
)

func main() {
	prometheus.MustRegister(internal.BlockHeight)
	prometheus.MustRegister(internal.NumPeers)

	// Metrics endpoint
	http.Handle("/metrics", promhttp.Handler())

	go func() {
		for {
			internal.UpdateMetrics(rpcURL, rpcUser, rpcPassword)
			time.Sleep(10 * time.Second) // Update every 10s
		}
	}()

	log.Println("Bitcoin Exporter running on :9100")
	http.ListenAndServe(":9100", nil)
}
