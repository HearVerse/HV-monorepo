# HV-monorepo
Create NFT marketplace contract through hardhat

## Setup environment
Run `yarn install` to install the npm modules

Put the private key of deployer in the env file. Note: you must don't share this key

## Change the hardhat.config.js

Now, the network is setted as ETH testnet.
If you want to deploy to mainnet or other networks, you can add or change on the networks property on hardhat.config.js

## Deploy the NFT marketplace contract

To deploy the NFT marketplace contract, you must set the fee and tresury account on `deploy/deployNFTMarketplace.js`.

Run `npx hardhat run deploy/deployNFTMarketplace.js --network <network name>` to deploy the contract on blockchain network

