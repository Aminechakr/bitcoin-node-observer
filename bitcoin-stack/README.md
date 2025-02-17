# Package and deploy the Umbrella Chart

````bash
helm dependency update
helm package .
helm install bitcoin-stack ./bitcoin-stack-0.1.0.tgz --namespace bitcoind
helm upgrade --install bitcoin-stack ./bitcoin-stack-0.1.0.tgz --namespace bitcoind
````