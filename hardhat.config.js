require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");

/** @type import('hardhat/config').HardhatUserConfig */
const Private_key = process.env.DEPLOY_PRIVATE_KEY;
module.exports = {
  defaultNetwork: "mumbai",
  networks: {
    mumbai: {
      url: "https://goerli.blockpi.network/v1/rpc/public",
      accounts: [`0x${Private_key}`]
    },
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000
  }
};
