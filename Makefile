validate-dydx-testnet-2-gentx:
	docker build --platform linux/amd64 --tag public-testnet-validate $(CURDIR)
	docker run --platform linux/amd64 \
		-e VALIDATE_GENESIS_DIR_PATH=./dydx-testnet-2 \
		-e VALIDATE_GENESIS_TAR_PATH=./dydx-testnet-2/binaries/v0.1.4/dydxprotocold-v0.1.4-linux-amd64.tar.gz \
		-e VALIDATE_GENESIS_STAKE_TOKEN=dv4tnt \
		-e GENESIS_FILE_NAME=pregenesis.json \
		-e ADD_GENTXS=true \
		-v $(CURDIR):/workspace \
		public-testnet-validate 

validate-dydx-testnet-2-final-genesis:
	docker build --platform linux/amd64 --tag public-testnet-validate $(CURDIR)
	docker run --platform linux/amd64 \
		-e VALIDATE_GENESIS_DIR_PATH=./dydx-testnet-2 \
		-e VALIDATE_GENESIS_TAR_PATH=./dydx-testnet-2/binaries/v0.1.4/dydxprotocold-v0.1.4-linux-amd64.tar.gz \
		-e VALIDATE_GENESIS_STAKE_TOKEN=dv4tnt \
		-e GENESIS_FILE_NAME=genesis.json \
		-e ADD_GENTXS=false \
		-v $(CURDIR):/workspace \
		public-testnet-validate 

.PHONY: validate-dydx-testnet-2-gentx validate-dydx-testnet-2-final-genesis
