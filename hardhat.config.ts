/* global task ethers */

import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-waffle";
//import '@nomiclabs/hardhat-truffle5'
import "@nomiclabs/hardhat-etherscan";

require("dotenv").config();
require("solidity-coverage");

require("./tasks/generateFactoryDiamondAbi");
require("./tasks/generateVaultDiamondAbi");

// You have to export an object to set up your config
// This object can have the following optional entries:
// defaultNetwork, networks, solc, and paths.
// Go to https://buidler.dev/config/ to learn more
module.exports = {
  mocha: {
    timeout: 100000000,
  },
  etherscan: {
    apiKey: process.env.POLYGON_API_KEY,
  },
  networks: {
    hardhat: {
      ...(process.env.MATIC_URL
        ? {
            forking: {
              url: process.env.MATIC_URL,
            },
          }
        : {}),
      blockGasLimit: 20_000_000,
      // NOTE: set a fixed chainId so deployments are deterministic across forks
      chainId: 31337,
    },
    localhost: {
      chainId: 31337,
    },
    matic: {
      url: process.env.MATIC_URL || "",
      accounts: process.env.SECRET ? [process.env.SECRET] : [],
      blockGasLimit: 200_000_000_000,
      gasPrice: 10_000_000_000,
    },
  },
  gasReporter: {
    currency: "USD",
    gasPrice: 100,
    enabled: false,
  },
  contractSizer: {
    alphaSort: false,
    runOnCompile: false,
    disambiguatePaths: true,
  },
  // This is a sample solc configuration that specifies which version of solc to use
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
};
