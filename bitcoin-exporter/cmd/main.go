package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/aminechakr/bitcoin-exporter/internal"
)

func main() {

    rpcURL := os.Getenv("RPC_URL")
    rpcUser := os.Getenv("RPC_USER")
    rpcPassword := os.Getenv("RPC_PASSWORD")
    metricsPortStr := os.Getenv("METRICS_PORT")

    if rpcURL == "" || rpcUser == "" || rpcPassword == "" || metricsPortStr == "" {
        log.Fatalf("Missing required configuration values")
    }

	metricsPort, err := strconv.Atoi(metricsPortStr)
    if err != nil {
        log.Fatalf("Invalid metrics port: %v", err)
    }

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

	log.Printf("Bitcoin Exporter running on: %d", metricsPort)
	log.Printf("RPC URL: %s", rpcURL)
    log.Printf("RPC User: %s", rpcUser)
    log.Printf("RPC Password: %s", rpcPassword)
	http.ListenAndServe(fmt.Sprintf(":%d", metricsPort), nil)
}
