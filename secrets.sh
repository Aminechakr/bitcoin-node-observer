#!/bin/bash

# Configure Vault CLI
export VAULT_ADDR='http://vault.local'
export VAULT_SKIP_VERIFY=true

# Check if Vault is initialized and unsealed
INIT_STATUS=$(vault status -format=json 2>/dev/null)
IS_INITIALIZED=$(echo $INIT_STATUS | jq -r '.initialized')
IS_SEALED=$(echo $INIT_STATUS | jq -r '.sealed')

if [[ "$IS_INITIALIZED" == "true" && "$IS_SEALED" == "false" ]]; then
    echo "Vault is ready. Creating secrets..."

    # Enable KV secrets engine
    vault secrets enable -path=secret kv-v2

    # Create Bitcoin RPC secrets,policy and role
    vault kv put secret/bitcoin-stack rpcuser="$BITCOIN_RPC_USER" rpcpassword="$BITCOIN_RPC_PASSWORD"
    echo "Bitcoin stack secrets created."

    vault policy write bitcoin-stack  - <<EOF
    path "secret/data/bitcoin-stack" {
    capabilities = ["read"]
    }
EOF

    vault write auth/kubernetes/role/bitcoin-stack \
    bound_service_account_names=vault-auth-bitcoin \
    bound_service_account_namespaces=bitcoind \
    policies=bitcoin-stack \
    ttl=1h

    # Create Grafana secrets,policy and role
    vault kv put secret/grafana adminUser="$GRAFANA_ADMIN_USER" adminPassword="$GRAFANA_ADMIN_PASSWORD"
    echo "Grafana secrets created."

    vault policy write grafana - <<EOF
    path "secret/data/grafana" {
    capabilities = ["read"]
    }
EOF

    vault write auth/kubernetes/role/grafana \
    bound_service_account_names=vault-auth-grafana \
    bound_service_account_namespaces=monitoring \
    policies=grafana \
    ttl=1h
else
    echo "Vault is not ready. Please ensure Vault is initialized and unsealed."
    exit 1
fi