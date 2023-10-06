#!/bin/bash

# Create a genesis.json using the gentx and pregenesis.json

set -euo pipefail

dir_path=$VALIDATE_GENESIS_DIR_PATH
genesis_file=$GENESIS_FILE_NAME
tar_url=$VALIDATE_GENESIS_TAR_URL
stake_token=$VALIDATE_GENESIS_STAKE_TOKEN
add_gentxs=$ADD_GENTXS

tar_path='/tmp/dydxprotocold/dydxprotocold.tar.gz'
mkdir -p /tmp/dydxprotocold
curl -vL $tar_url -o $tar_path
dydxprotocold_path=$(tar -xvf $tar_path --directory /tmp/dydxprotocold)
mkdir -p ~/bin
cp /tmp/dydxprotocold/$dydxprotocold_path /usr/local/bin/dydxprotocold


dydxprotocold init --chain-id=dydx-mainnet-1 dydx-1
cp $dir_path/$genesis_file ~/.dydxprotocol/config/genesis.json

if [ "$add_gentxs" = "true" ]; then
  mkdir ~/.dydxprotocol/config/gentx
  cp $dir_path/gentx/* ~/.dydxprotocol/config/gentx

  dydxprotocold collect-gentxs
else
  echo "Validating final genesis, skip adding gentxs..."
fi

dydxprotocold validate-genesis

# NB: We assume that if the binary runs for 15 seconds, the genesis transactions have been run
# Running dydxprotocold with timeout yields 143 if timed out during startup, and 0 if timed out afterwards.
# This is probably due to how the binary handles the SIGTERM that timeout sends. We only allow error code 0.
timeout 15 dydxprotocold start
echo "Terminated successfully!"

# Only upload `genesis.new.json` if we're adding gentxs (validating gentx submission).
if [ "$add_gentxs" = "true" ]; then
  cp ~/.dydxprotocol/config/genesis.json $dir_path/genesis.new.json
fi
