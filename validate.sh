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

add_genesis_account () {
  find "$1" -type f -name "*.json" | while read json_file; do
    delegator_address=$(jq -r '.body.messages[0].delegator_address' "$json_file")
    moniker=$(jq -r '.body.messages[0].description.moniker' "$json_file")

    if [ "$moniker" != "dydx-1" ] && [ "$moniker" != "dydx-2" ] && [ "$moniker" != "dydx-research" ]; then
      denom=$(jq -r '.body.messages[0].value.denom' "$json_file")
      amount=$(jq -r '.body.messages[0].value.amount' "$json_file")

      if [ "$amount$denom" != "50000000000$stake_token" ]; then
          echo "Expected 50000000000$stake_token delegated tokens, but got $amount$denom"
          exit 1
      fi

      echo "Adding genesis for $delegator_address"
      dydxprotocold add-genesis-account "$delegator_address" 100000000000$stake_token
    fi
  done
}

dydxprotocold init --chain-id=dydx-mainnet-1 dydx-1
cp $dir_path/$genesis_file ~/.dydxprotocol/config/genesis.json

if [ "$add_gentxs" = "true" ]; then
  echo "Adding gentxs to pregenesis..."
  add_genesis_account $dir_path/gentx

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
