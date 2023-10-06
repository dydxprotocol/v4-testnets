validate-dydx-mainnet-1-gentx:
	docker build --platform linux/amd64 --tag public-mainnet-validate $(CURDIR)
	docker run --platform linux/amd64 \
		-e VALIDATE_GENESIS_DIR_PATH=./dydx-mainnet-1 \
		-e VALIDATE_GENESIS_TAR_URL='https://github.com/dydxprotocol/v4-chain/releases/download/protocol%2Fv0.3.1/dydxprotocold-v0.3.1-linux-amd64.tar.gz' \
		-e VALIDATE_GENESIS_STAKE_TOKEN=adydx \
		-e GENESIS_FILE_NAME=pregenesis.json \
		-e ADD_GENTXS=true \
		-v $(CURDIR):/workspace \
		public-mainnet-validate 

validate-dydx-mainnet-1-final-genesis:
	docker build --platform linux/amd64 --tag public-mainnet-validate $(CURDIR)
	docker run --platform linux/amd64 \
		-e VALIDATE_GENESIS_DIR_PATH=./dydx-mainnet-1 \
		-e VALIDATE_GENESIS_TAR_URL='https://github.com/dydxprotocol/v4-chain/releases/download/protocol%2Fv0.3.1/dydxprotocold-v0.3.1-linux-amd64.tar.gz' \
		-e VALIDATE_GENESIS_STAKE_TOKEN=adydx \
		-e GENESIS_FILE_NAME=genesis.json \
		-e ADD_GENTXS=false \
		-v $(CURDIR):/workspace \
		public-mainnet-validate 

.PHONY: validate-dydx-mainnet-1-gentx validate-dydx-mainnet-1-final-genesis
