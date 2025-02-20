#!/bin/bash

export VAULT_ADDR='http://vault.local'
export VAULT_SKIP_VERIFY=true

wait_for_vault() {
    echo "Waiting for Vault to be ready..."
    while true; do
        # Check if Vault is reachable
        if curl -s -o /dev/null --head --fail "$VAULT_ADDR/v1/sys/health"; then
            echo "Vault is ready!"
            break
        else
            echo "Vault is not ready yet. Retrying in 5 seconds..."
            sleep 5
        fi
    done
}
wait_for_vault

# Check if Vault is already initialized
INIT_STATUS=$(vault status -format=json 2>/dev/null)
IS_INITIALIZED=$(echo $INIT_STATUS | jq -r '.initialized')

if [[ "$IS_INITIALIZED" == "false" ]]; then
    echo "Initializing Vault..."
    INIT_OUTPUT=$(vault operator init -format=json)
    
    echo "$INIT_OUTPUT" > vault-keys.json
    echo "Initialization data saved to vault-keys.json"
    
    UNSEAL_KEY_1=$(echo $INIT_OUTPUT | jq -r '.unseal_keys_b64[0]')
    UNSEAL_KEY_2=$(echo $INIT_OUTPUT | jq -r '.unseal_keys_b64[1]')
    UNSEAL_KEY_3=$(echo $INIT_OUTPUT | jq -r '.unseal_keys_b64[2]')
    ROOT_TOKEN=$(echo $INIT_OUTPUT | jq -r '.root_token')
    
    echo "Extracted Keys:"
    echo "Unseal Key 1: $UNSEAL_KEY_1"
    echo "Unseal Key 2: $UNSEAL_KEY_2"
    echo "Unseal Key 3: $UNSEAL_KEY_3"
    echo "Root Token: $ROOT_TOKEN"
    
    {
        echo "Vault Initialization Details"
        echo "=========================="
        echo "Unseal Key 1: $UNSEAL_KEY_1"
        echo "Unseal Key 2: $UNSEAL_KEY_2"
        echo "Unseal Key 3: $UNSEAL_KEY_3"
        echo "Root Token: $ROOT_TOKEN"
        echo "=========================="
        echo "Generated on: $(date)"
    } > vault-keys.txt
    
    echo "Keys also saved in human-readable format to vault-keys.txt"
    
    echo "Unsealing Vault..."
    vault operator unseal $UNSEAL_KEY_1
    vault operator unseal $UNSEAL_KEY_2
    vault operator unseal $UNSEAL_KEY_3
    
    echo "Logging into Vault..."
    vault login $ROOT_TOKEN
else
    echo "Vault is already initialized. Please unseal manually with your existing keys."
    exit 1
fi

chmod 600 vault-keys.json vault-keys.txt
echo "Vault setup complete!"


# Enable Kubernetes auth
vault auth enable kubernetes
vault write auth/kubernetes/config \
    kubernetes_host="https://kubernetes.default.svc" \
    kubernetes_ca_cert="$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)" \
    issuer="https://kubernetes.default.svc.cluster.local"

echo "Kubernetes authentication configured in Vault."
