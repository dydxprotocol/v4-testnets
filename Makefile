validate-dydx-testnet-4-gentx:
	docker build --platform linux/amd64 --tag public-testnet-validate $(CURDIR)
	docker run --platform linux/amd64 \
		-e VALIDATE_GENESIS_DIR_PATH=./dydx-testnet-4 \
		-e VALIDATE_GENESIS_TAR_URL='https://github.com/dydxprotocol/v4-chain/releases/download/testnet4-validate/dydxprotocold-testnet4-validate-linux-amd64.tar.gz' \
		-e VALIDATE_GENESIS_STAKE_TOKEN=adv4tnt \
		-e GENESIS_FILE_NAME=pregenesis.json \
		-e ADD_GENTXS=true \
		-v $(CURDIR):/workspace \
		public-testnet-validate 

validate-dydx-testnet-4-final-genesis:
	docker build --platform linux/amd64 --tag public-testnet-validate $(CURDIR)
	docker run --platform linux/amd64 \
		-e VALIDATE_GENESIS_DIR_PATH=./dydx-testnet-4 \
		-e VALIDATE_GENESIS_TAR_URL='https://github.com/dydxprotocol/v4-chain/releases/download/protocol%2Fv0.3.6/dydxprotocold-v0.3.6-linux-amd64.tar.gz' \
		-e VALIDATE_GENESIS_STAKE_TOKEN=adv4tnt \
		-e GENESIS_FILE_NAME=genesis.json \
		-e ADD_GENTXS=false \
		-v $(CURDIR):/workspace \
		public-testnet-validate 

.PHONY: validate-dydx-testnet-4-gentx validate-dydx-testnet-4-final-genesis
