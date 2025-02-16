package internal

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

type RPCRequest struct {
	JsonRPC string        `json:"jsonrpc"`
	Method  string        `json:"method"`
	Params  []interface{} `json:"params"`
	ID      int           `json:"id"`
}

type RPCResponse struct {
	Result json.RawMessage `json:"result"`
	Error  interface{}     `json:"error"`
	ID     int             `json:"id"`
}

func CallBitcoinRPC(rpcURL, rpcUser, rpcPassword, method string, params []interface{}) (json.RawMessage, error) {
	requestBody, _ := json.Marshal(RPCRequest{
		JsonRPC: "1.0",
		Method:  method,
		Params:  params,
		ID:      1,
	})

	req, err := http.NewRequest("POST", rpcURL, bytes.NewBuffer(requestBody))
	if err != nil {
		return nil, err
	}
	req.SetBasicAuth(rpcUser, rpcPassword)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var rpcResponse RPCResponse
	if err := json.Unmarshal(body, &rpcResponse); err != nil {
		return nil, err
	}

	if rpcResponse.Error != nil {
		return nil, fmt.Errorf("RPC error: %v", rpcResponse.Error)
	}

	return rpcResponse.Result, nil
}
