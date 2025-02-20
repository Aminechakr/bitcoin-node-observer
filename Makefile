# Makefile for deploying Bitcoin Stack with Vault and Monitoring
include .env
export $(shell sed 's/=.*//' .env)

# Variables
VAULT_CHART := ./vault
MONITORING_CHART := ./observability
BITCOIN_STACK_CHART := ./bitcoin-stack

# Target to build Helm dependencies for Vault
build-vault-dependencies:
	@echo "Building Vault dependencies..."
	helm dependency build $(VAULT_CHART)
	@echo "Vault dependencies built successfully!"

# Target to deploy Vault
deploy-vault: build-vault-dependencies
	@echo "Deploying Vault..."
	helm repo add hashicorp https://helm.releases.hashicorp.com || echo "Hashicorp repo already added."
	helm upgrade --install vault $(VAULT_CHART) -f $(VAULT_CHART)/values.yaml
	@echo "Vault deployed successfully!"

configure-vault:
	@echo "Configuring and unsealing Vault..."
	./configure.sh
	@echo "Vault configuration complete!"

create-secrets:
	@echo "Creating secrets in Vault..."
	./secrets.sh
	@echo "Secrets created successfully!"

# Target to build Helm dependencies for Monitoring
build-monitoring-dependencies:
	@echo "Building Monitoring dependencies..."
	helm dependency build $(MONITORING_CHART)
	@echo "Monitoring dependencies built successfully!"

# Target to deploy the Monitoring stack (Prometheus + Grafana)
deploy-monitoring: build-monitoring-dependencies
	@echo "Deploying Monitoring Stack..."
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || echo "Prometheus repo already added."
	helm repo add grafana https://grafana.github.io/helm-charts || echo "Grafana repo already added."
	helm upgrade --install monitoring $(MONITORING_CHART) -f $(MONITORING_CHART)/values.yaml
	@echo "Monitoring Stack deployed successfully!"

# Target to deploy the Bitcoin stack (Bitcoin Node + Bitcoin Exporter)
deploy-bitcoin-stack:
	@echo "Deploying Bitcoin Stack..."
	helm dependency build $(BITCOIN_STACK_CHART)
	helm upgrade --install bitcoin-stack $(BITCOIN_STACK_CHART) -f $(BITCOIN_STACK_CHART)/values.yaml || (echo "Bitcoin Stack deployment failed!"; exit 1)
	@echo "Bitcoin Stack deployed successfully!"

# Target to deploy everything in the correct order
deploy-all: deploy-vault configure-vault create-secrets deploy-monitoring deploy-bitcoin-stack
	@echo "All components deployed successfully!"

# Target to clean up resources
clean:
	@echo "Cleaning up resources..."
	@helm uninstall vault 2>/dev/null || true
	@helm uninstall monitoring 2>/dev/null || true
	@helm uninstall bitcoin-stack 2>/dev/null || true
	@echo "Cleanup complete!"
