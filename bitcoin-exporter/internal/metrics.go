package internal

import (
	"encoding/json"
	"log"
	"github.com/prometheus/client_golang/prometheus"
)

var (
	BlockHeight = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "bitcoin_block_height",
		Help: "Current block height of the Bitcoin node",
	})

	NumPeers = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "bitcoin_peers",
		Help: "Number of connected peers to the Bitcoin node",
	})
)

func UpdateMetrics(rpcURL, rpcUser, rpcPassword string) {
	// Fetch block height
	blockHeightResp, err := CallBitcoinRPC(rpcURL, rpcUser, rpcPassword, "getblockcount", []interface{}{})
	if err == nil {
		var height int
		json.Unmarshal(blockHeightResp, &height)
		BlockHeight.Set(float64(height))
	} else {
		log.Println("Error fetching block height:", err)
	}

	// Fetch number of peers
	peerInfoResp, err := CallBitcoinRPC(rpcURL, rpcUser, rpcPassword, "getpeerinfo", []interface{}{})
	if err == nil {
		var peers []interface{}
		json.Unmarshal(peerInfoResp, &peers)
		NumPeers.Set(float64(len(peers)))
	} else {
		log.Println("Error fetching peer count:", err)
	}
}
