/* global task ethers */
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

// This is a sample Buidler task. To learn how to create your own go to
// https://buidler.dev/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(await account.getAddress());
  }
});

// You have to export an object to set up your config
// This object can have the following optional entries:
// defaultNetwork, networks, solc, and paths.
// Go to https://buidler.dev/config/ to learn more
module.exports = {
  networks: {
    hardhat: {
      blockGasLimit: 20000000,
      timeout: 60000,
      gas: "auto",
    },
    localhost: {
      timeout: 160000,
    },

    kovan: {
      url: process.env.KOVAN_URL,
      accounts: [process.env.SECRET],
      gasPrice: 5000000000,
    },
    //  ethereum: {
    //    url: process.env.MAINNET_URL,
    //   accounts: [process.env.SECRET],
    //   blockGasLimit: 12000000,
    //  gasPrice: 80000000000
    // }
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
        version: "0.8.1",
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
