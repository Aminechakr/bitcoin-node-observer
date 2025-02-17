# bitcoin-node-observer
A Signet BTC node deployed on K8S with a custom exporter for observability

# 1 / BTC signet deployment

# Signet Docker sample 
````bash
#Run Docker image: 
docker run --rm -it \
  bitcoin/bitcoin \
  -p 38332:38332 \
  -p 38333:38333 \
  -printtoconsole \
  -signet=1 \
  -rpcallowip=0.0.0.0/0 \
  -rpcbind=0.0.0.0 \
  -rpcuser=foo \
  -rpcpassword=bar \
  -rpcport=38332
````

# Helm deploy
- Check `README.md` of bitcoind for more details.


# Exporter build/deploy
- Check `README.md` of bitcoin-exporter for more details.

# One click stack deploy
- Check `RADME.md` of bitcoin-stack for more details.
